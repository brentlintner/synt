"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.find = void 0;
const escodegen = require("@javascript-obfuscator/escodegen");
const espree = require("espree");
const estraverse = require("estraverse");
const fs = require("fs");
const _ = require("lodash");
const FUNCTION_OR_CLASS_NODE = [
    espree.Syntax.ArrowFunctionExpression,
    espree.Syntax.ClassDeclaration,
    espree.Syntax.FunctionDeclaration,
    espree.Syntax.FunctionExpression
];
const normalize = (token_list) => _.map(token_list, (t) => t.value);
const tokenize = (code, opts) => {
    const tokenize_opts = {
        ecmaVersion: opts.ecmaVersion || "latest",
        sourceType: opts.sourceType || "module"
    };
    return normalize(espree.tokenize(code, tokenize_opts));
};
const astify = (code, opts) => {
    const module_type = opts.sourceType || "module";
    const ecma_version = opts.ecmaVersion || "latest";
    const parse_opts = {
        ecmaVersion: ecma_version,
        loc: true,
        sourceType: module_type
    };
    return espree.parse(code, parse_opts);
};
const ast_to_code = (node) => {
    const opts = { format: { indent: { style: "  " } } };
    return escodegen.generate(node, opts);
};
const is_a_method_or_class = (node) => _.some(FUNCTION_OR_CLASS_NODE, (type) => type === node.type);
const line_info = (node) => node.loc;
const parse_methods_and_classes = (root_node, filepath, opts) => {
    const entries = [];
    estraverse.traverse(root_node, {
        enter(node, _parent) {
            if (!is_a_method_or_class(node))
                return;
            const method = ast_to_code(node);
            const tokens = tokenize(method, opts);
            const is_class = node.type === espree.Syntax.ClassDeclaration;
            const result = {
                ast: node,
                code: method,
                is_class,
                path: filepath,
                pos: line_info(node),
                tokens,
                type: node.type
            };
            entries.push(result);
        }
    });
    return entries;
};
const find_similar_methods_and_classes = (filepaths, opts) => _.flatMap(filepaths, (filepath) => {
    const code = fs.readFileSync(filepath).toString();
    let node;
    try {
        node = astify(code, opts);
    }
    catch (err) {
        throw new Error(`in ${filepath}\n\n${_.get(err, "stack", err)}`);
    }
    return parse_methods_and_classes(node, filepath, opts);
});
exports.find = find_similar_methods_and_classes;
