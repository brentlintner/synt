import * as escodegen from "@javascript-obfuscator/escodegen"
import * as espree from "espree"
import * as estraverse from "estraverse"
import * as es from "estree"
import * as fs from "fs"
import * as _ from "lodash"

const FUNCTION_OR_CLASS_NODE : string[] = [
  espree.Syntax.ArrowFunctionExpression,
  espree.Syntax.ClassDeclaration,
  espree.Syntax.FunctionDeclaration,
  espree.Syntax.FunctionExpression
  // TODO: (FE/FD causes dupe of MD)
  // espree.Syntaxt.MethodDefinition
  ]

const normalize = (
  token_list : espree.Token[]
) : string[] =>
  _.map(token_list, (t : espree.Token) => t.value)

const tokenize = (code : string, opts : synt.CompareOptions) : string[] => {
  const tokenize_opts : espree.Options = {
    ecmaVersion: opts.ecmaVersion || "latest",
    sourceType: opts.sourceType || "module"
  }

  return normalize(espree.tokenize(code, tokenize_opts))
}

const astify = (
  code : string,
  opts : synt.CompareOptions
) : es.Program => {
  const module_type : string = opts.sourceType || "module"
  const ecma_version : string | number = opts.ecmaVersion || "latest"
  const parse_opts : espree.Options = {
    ecmaVersion: ecma_version,
    loc: true,
    sourceType: module_type
  }
  return espree.parse(code, parse_opts)
}

const ast_to_code = (node : es.Node) => {
  const opts = { format: { indent: { style: "  " } } }
  return escodegen.generate(node, opts)
}

const is_a_method_or_class = (node : es.Node) =>
  _.some(FUNCTION_OR_CLASS_NODE, (type) => type === node.type)

const line_info = (node : es.Node) : es.SourceLocation => node.loc

const parse_methods_and_classes = (
  root_node : es.Node,
  filepath : string,
  opts : synt.CompareOptions
) : synt.ParseResult[] => {
  const entries : synt.ParseResult[] = []

  // TODO: need to construct a proper parent chain
  estraverse.traverse(root_node, {
    enter(node : es.Node, _parent : es.Node) {
      if (!is_a_method_or_class(node)) return
      const method = ast_to_code(node)
      const tokens = tokenize(method, opts)
      const is_class = node.type === espree.Syntax.ClassDeclaration
      const result = {
        ast: node,
        code: method,
        is_class,
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
  filepaths : string[],
  opts : synt.CompareOptions
) : synt.ParseResult[] =>
  _.flatMap(filepaths, (filepath) => {
    const code = fs.readFileSync(filepath).toString()
    let node : es.Node

    try {
      node = astify(code, opts)
    } catch (err) {
      throw new Error(`in ${filepath}\n\n${_.get(err, "stack", err)}`)
    }

    return parse_methods_and_classes(node, filepath, opts)
  })

export {
  find_similar_methods_and_classes as find
}
