"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.find = void 0;
const _ = require("lodash");
const fs = require("fs");
const ts = require("typescript");
const STOP_AT_NODES = [
    ts.SyntaxKind.ArrayType,
    ts.SyntaxKind.PrefixUnaryExpression,
    ts.SyntaxKind.RegularExpressionLiteral
];
const FUNCTION_OR_CLASS_NODE = [
    ts.SyntaxKind.ArrowFunction,
    ts.SyntaxKind.ClassDeclaration,
    ts.SyntaxKind.Constructor,
    ts.SyntaxKind.FunctionDeclaration,
    ts.SyntaxKind.FunctionExpression,
    ts.SyntaxKind.MethodDeclaration
];
const PASSTHROUGH_NODES = FUNCTION_OR_CLASS_NODE.concat([
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
const astify = (code, filepath, _opts) => {
    ts.createProgram([filepath], {});
    return ts.createSourceFile(filepath, code, ts.ScriptTarget.Latest, true, ts.ScriptKind.TS);
};
const is_a_base_node = (node) => _.some(STOP_AT_NODES, (kind) => kind === node.kind);
const is_a_passthrough_node = (node) => _.some(PASSTHROUGH_NODES, (kind) => kind === node.kind);
const is_a_method_or_class = (node) => _.some(FUNCTION_OR_CLASS_NODE, (kind) => kind === node.kind);
const _tokenize = (tokens) => (node) => {
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
};
const tokenize = (ast_node) => {
    const tokens = [];
    _tokenize(tokens)(ast_node);
    return tokens;
};
const find_all_methods_and_classes = (list) => (node) => {
    if (is_a_method_or_class(node)) {
        list.push(node);
    }
    ts.forEachChild(node, find_all_methods_and_classes(list));
};
const line_info = (node, root_node) => {
    const { line, character } = root_node
        .getLineAndCharacterOfPosition(node.getStart());
    return {
        start: {
            column: character,
            line: line + 1
        }
    };
};
const parse_methods_and_classes = (node, root_node, path) => {
    const methods_and_classes = [];
    find_all_methods_and_classes(methods_and_classes)(node);
    return _.map(methods_and_classes, (method_or_class) => {
        const tokens = tokenize(method_or_class);
        const code = method_or_class.getText();
        const is_class = method_or_class.kind == ts.SyntaxKind.ClassDeclaration;
        return {
            ast: method_or_class,
            code,
            is_class,
            path,
            pos: line_info(method_or_class, root_node),
            tokens,
            type: ts.SyntaxKind[method_or_class.kind]
        };
    });
};
const find_similar_methods_and_classes = (filepaths, opts) => _.flatMap(filepaths, (filepath) => {
    const code = fs.readFileSync(filepath).toString();
    const node = astify(code, filepath, opts);
    const root_node = node;
    return parse_methods_and_classes(node, root_node, filepath);
});
exports.find = find_similar_methods_and_classes;
