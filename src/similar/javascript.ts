import fs = require("fs")
import _ = require("lodash")
import codegen = require("escodegen")
import esprima = require("esprima")
import estraverse = require("estraverse")

import * as es from "estree"

const FUNCTION_OR_CLASS_NODE : string[] = [
  esprima.Syntax.ArrowFunctionExpression,
  esprima.Syntax.ClassDeclaration,
  esprima.Syntax.FunctionDeclaration,
  esprima.Syntax.FunctionExpression
  // TODO: (FE/FD causes dupe of MD)
  // esprima.Syntaxt.MethodDefinition
  ]

const normalize = (
  token_list : esprima.Token[]
) : string[] =>
  _.map(token_list, (t : esprima.Token) => t.value)

const tokenize = (code : string) : string[] =>
  normalize(esprima.tokenize(code))

const astify = (code : string) : es.Program =>
  esprima.parse(code, { loc: true })

const ast_to_code = (node : es.Node) => {
  const opts = { format: { indent: { style: "  " } } }
  return codegen.generate(node, opts)
}

const is_a_method_or_class = (node : es.Node) =>
  _.some(FUNCTION_OR_CLASS_NODE, (type) => type === node.type)

const line_info = (node : es.Node) : es.SourceLocation => node.loc

const parse_methods_and_classes = (
  root_node : es.Node,
  filepath : string
) : synt.ParseResult[] => {
  const entries : synt.ParseResult[] = []

  // TODO: need to construct a proper parent chain
  estraverse.traverse(root_node, {
    enter(node : es.Node, parent : es.Node) {
      if (!is_a_method_or_class(node)) return
      const method = ast_to_code(node)
      const tokens = tokenize(method)
      const is_class = node.type === esprima.Syntax.ClassDeclaration
      const result = {
        ast: node,
        code: method,
        is_class: is_class,
        path: filepath,
        pos: line_info(node),
        tokens,
        type: node.type
      }
      entries.push(result)
    }
  })

  return entries
}

const find_similar_methods_and_classes = (
  filepaths : string[]
) : synt.ParseResult[] =>
  _.flatMap(filepaths, (filepath) => {
    const code = fs.readFileSync(filepath).toString()
    const node = astify(code)
    return parse_methods_and_classes(node, filepath)
  })

export = {
  find: find_similar_methods_and_classes
} as synt.Module.SimilarJS
