"use strict";
var _ = require("lodash");
var fs = require("fs");
var ts = require("typescript");
var STOP_AT_NODES = [
    ts.SyntaxKind.ArrayType,
    ts.SyntaxKind.PrefixUnaryExpression,
    ts.SyntaxKind.RegularExpressionLiteral
];
var FUNCTION_OR_CLASS_NODE = [
    ts.SyntaxKind.ArrowFunction,
    ts.SyntaxKind.ClassDeclaration,
    ts.SyntaxKind.Constructor,
    ts.SyntaxKind.FunctionDeclaration,
    ts.SyntaxKind.FunctionExpression,
    ts.SyntaxKind.MethodDeclaration
];
var PASSTHROUGH_NODES = FUNCTION_OR_CLASS_NODE.concat([
    ts.SyntaxKind.ArrowFunction,
    ts.SyntaxKind.ArrayLiteralExpression,
    ts.SyntaxKind.BinaryExpression,
    ts.SyntaxKind.Block,
    ts.SyntaxKind.CallExpression,
    ts.SyntaxKind.CatchClause,
    ts.SyntaxKind.ConditionalExpression,
    ts.SyntaxKind.ElementAccessExpression,
    ts.SyntaxKind.ExpressionStatement,
    ts.SyntaxKind.FirstNode,
    ts.SyntaxKind.FunctionExpression,
    ts.SyntaxKind.FunctionDeclaration,
    ts.SyntaxKind.FunctionType,
    ts.SyntaxKind.IfStatement,
    ts.SyntaxKind.IndexSignature,
    ts.SyntaxKind.NewExpression,
    ts.SyntaxKind.ObjectLiteralExpression,
    ts.SyntaxKind.Parameter,
    ts.SyntaxKind.ParenthesizedExpression,
    ts.SyntaxKind.PropertyAccessExpression,
    ts.SyntaxKind.PropertyAssignment,
    ts.SyntaxKind.PropertyDeclaration,
    ts.SyntaxKind.ReturnStatement,
    ts.SyntaxKind.TemplateExpression,
    ts.SyntaxKind.TemplateSpan,
    ts.SyntaxKind.TryStatement,
    ts.SyntaxKind.TypeReference,
    ts.SyntaxKind.TypeLiteral,
    ts.SyntaxKind.VariableDeclaration,
    ts.SyntaxKind.VariableDeclarationList,
    ts.SyntaxKind.VariableStatement
]);
var astify = function (code, filepath, opts) {
    ts.createProgram([filepath], {});
    return ts.createSourceFile(filepath, code, ts.ScriptTarget.Latest, true, ts.ScriptKind.TS);
};
var is_a_base_node = function (node) {
    return _.some(STOP_AT_NODES, function (kind) { return kind === node.kind; });
};
var is_a_passthrough_node = function (node) {
    return _.some(PASSTHROUGH_NODES, function (kind) { return kind === node.kind; });
};
var is_a_method_or_class = function (node) {
    return _.some(FUNCTION_OR_CLASS_NODE, function (kind) { return kind === node.kind; });
};
var _tokenize = function (tokens) { return function (node) {
    if (is_a_base_node(node)) {
        tokens.push(node.getText());
    }
    else if (is_a_passthrough_node(node)) {
        ts.forEachChild(node, _tokenize(tokens));
    }
    else {
        tokens.push(node.getText());
        ts.forEachChild(node, _tokenize(tokens));
    }
}; };
var tokenize = function (ast_node) {
    var tokens = [];
    _tokenize(tokens)(ast_node);
    return tokens;
};
var find_all_methods_and_classes = function (list) { return function (node) {
    if (is_a_method_or_class(node)) {
        list.push(node);
    }
    ts.forEachChild(node, find_all_methods_and_classes(list));
}; };
var line_info = function (node, root_node) {
    var _a = root_node
        .getLineAndCharacterOfPosition(node.getStart()), line = _a.line, character = _a.character;
    return {
        start: {
            column: character,
            line: line + 1
        }
    };
};
var parse_methods_and_classes = function (node, root_node, path) {
    var methods_and_classes = [];
    find_all_methods_and_classes(methods_and_classes)(node);
    return _.map(methods_and_classes, function (method_or_class) {
        var tokens = tokenize(method_or_class);
        var code = method_or_class.getText();
        var is_class = method_or_class.kind == ts.SyntaxKind.ClassDeclaration;
        return {
            ast: method_or_class,
            code: code,
            is_class: is_class,
            path: path,
            pos: line_info(method_or_class, root_node),
            tokens: tokens,
            type: ts.SyntaxKind[method_or_class.kind]
        };
    });
};
var find_similar_methods_and_classes = function (filepaths, opts) {
    return _.flatMap(filepaths, function (filepath) {
        var code = fs.readFileSync(filepath).toString();
        var node = astify(code, filepath, opts);
        var root_node = node;
        return parse_methods_and_classes(node, root_node, filepath);
    });
};
module.exports = {
    find: find_similar_methods_and_classes
};
