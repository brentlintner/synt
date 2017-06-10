"use strict";
var fs = require("fs");
var _ = require("lodash");
var codegen = require("escodegen");
var babel = require("babel-core");
var babylon = require("babylon");
var traverse = require("babel-traverse");
var generate = require("babel-generator");
var esprima = require("esprima");
var estraverse = require("estraverse");
var FUNCTION_OR_CLASS_NODE = [
    esprima.Syntax.ArrowFunctionExpression,
    esprima.Syntax.ClassDeclaration,
    esprima.Syntax.FunctionDeclaration,
    esprima.Syntax.FunctionExpression
];
var normalize = function (token_list) {
    return _.compact(_.map(token_list, function (t) {
      var val = t.value
      if (val == undefined) {
        if (t.type != babylon.tokTypes.eof) {
          val = t.type.label
        }
      }
      return val;
    }));
};
var tokenize = function (code) {
  var tokens = babylon.parse(code, {
    retainLines: true,
    concise: true,
    //plugins: [ "estree" ],
    plugins: [
      "jsx",
      "flow",
      "objectRestSpread",
      "classProperties",
      "classPrivateProperties"
    ]
  }).tokens
  //return _.map(esprima.tokenize(code), function (t) {
    //return t.value
  //})
  return normalize(tokens);
};
var astify = function (code, filename, opts) {
  var a = babylon.parse(code, {
    sourceType: _.get(opts, "estype", "module"),
    retainLines: true,
    concise: true,
    //plugins: [ "estree" ],
    plugins: [
      "jsx",
      "flow",
      "objectRestSpread",
      "classProperties",
      "classPrivateProperties"
    ]
    //presets: [
      //"env",
      //"react",
      //"flow",
      //"stage-3",
      //"stage-2"
    //]
  })
  return a
  //return a.ast
    //return esprima.parse(code, {
        //loc: true,
        //sourceType: _.get(opts, "estype", "module")
    //});
};
var ast_to_code = function (node) {
    //var opts = { format: { indent: { style: "  " } } };
    var opts = {
    }
    var s = generate.default(node, opts);
    return s.code
};
var is_a_method_or_class = function (node) {
    return _.some(FUNCTION_OR_CLASS_NODE, function (type) { return type === node.type; });
};
var line_info = function (node) {
  var s = _.get(node, "loc", { start: {}, end: {} });
  return s
};

var parse_methods_and_classes = function (root_node, filepath) {
    var entries = [];
    traverse.default(root_node, {
        enter: function (path) {
            var node = path.node;
            if (!is_a_method_or_class(node)) {
                return;
            }
            var method = ast_to_code(node);
            var tokens = tokenize(method);
            var is_class = node.type === esprima.Syntax.ClassDeclaration;
            var result = {
                ast: node,
                code: method,
                is_class: is_class,
                path: filepath,
                parent: path.parentPath.node,
                pos: line_info(node),
                tokens: tokens,
                type: node.type
            };
            entries.push(result);
        }
    });
    return entries;
};
var find_similar_methods_and_classes = function (filepaths, opts) {
    return _.flatMap(filepaths, function (filepath) {
        var code = fs.readFileSync(filepath).toString();
        var node;
        try {
            node = astify(code, filepath, opts);
        }
        catch (err) {
            throw new Error("in " + filepath + "\n\n" + err.stack);
        }
        return parse_methods_and_classes(node, filepath);
    });
};
module.exports = {
    find: find_similar_methods_and_classes
};
