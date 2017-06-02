import _ = require("lodash")
import fs = require("fs")
import ts = require("typescript")

// TODO: Write/use a proper lexer for TS code
//       This significantly simplifies tokenization
//       and so it may be less accurate than
//       matching using a properly lexed token stream

const STOP_AT_NODES : ts.SyntaxKind[] = [
  ts.SyntaxKind.ArrayType,
  ts.SyntaxKind.PrefixUnaryExpression,
  ts.SyntaxKind.RegularExpressionLiteral
]

const FUNCTION_OR_CLASS_NODE : ts.SyntaxKind[] = [
  ts.SyntaxKind.ArrowFunction,
  ts.SyntaxKind.ClassDeclaration,
  ts.SyntaxKind.Constructor,
  ts.SyntaxKind.FunctionDeclaration,
  ts.SyntaxKind.FunctionExpression,
  ts.SyntaxKind.MethodDeclaration
]

const PASSTHROUGH_NODES : ts.SyntaxKind[] = FUNCTION_OR_CLASS_NODE.concat([
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
])

const astify = (
  code : string,
  filepath : string
) : ts.SourceFile => {
  ts.createProgram([ filepath ], {})
  return ts.createSourceFile(
    filepath,
    code,
    ts.ScriptTarget.Latest,
    true, // setParentNodes
    ts.ScriptKind.TS)
}

const is_a_base_node = (node : ts.Node) : boolean =>
  _.some(STOP_AT_NODES, (kind) => kind === node.kind)

const is_a_passthrough_node = (node : ts.Node) : boolean =>
  _.some(PASSTHROUGH_NODES, (kind) => kind === node.kind)

const is_a_method_or_class = (node : ts.Node) : boolean =>
  _.some(FUNCTION_OR_CLASS_NODE, (kind) => kind === node.kind)

const _tokenize = (
  tokens : string[]
) => (
  node : ts.Node
) => {
  if (is_a_base_node(node)) {
    tokens.push(node.getText())
  } else if (is_a_passthrough_node(node)) {
    ts.forEachChild(node, _tokenize(tokens))
  } else {
    tokens.push(node.getText())
    ts.forEachChild(node, _tokenize(tokens))
  }
}

const tokenize = (ast_node : ts.Node) : string[] => {
  const tokens : string[] = []
  _tokenize(tokens)(ast_node)
  return tokens
}

const find_all_methods_and_classes = (
  list : ts.Node[]
) => (
  node : ts.Node
) => {
  if (is_a_method_or_class(node)) { list.push(node) }
  ts.forEachChild(node, find_all_methods_and_classes(list))
}

const line_info = (
  node : ts.Node,
  root_node : ts.SourceFile
) : synt.LineInfo => {
  const { line, character } = root_node
    .getLineAndCharacterOfPosition(node.getStart())
  return {
    start: {
      column: character,
      line: line + 1 // zero-indexed
    }
  }
}

const parse_methods_and_classes = (
  node : ts.Node,
  root_node : ts.SourceFile,
  path : string
) : synt.ParseResult[] => {
  const methods_and_classes : ts.Node[] = []

  find_all_methods_and_classes(methods_and_classes)(node)

  return _.map(methods_and_classes, (method_or_class : ts.Node) => {
    const tokens = tokenize(method_or_class)
    const code = method_or_class.getText()
    const is_class = method_or_class.kind == ts.SyntaxKind.ClassDeclaration
    return {
      ast: method_or_class,
      code,
      is_class,
      path,
      pos: line_info(method_or_class, root_node),
      tokens,
      type: ts.SyntaxKind[method_or_class.kind]
    }
  })
}

const find_similar_methods_and_classes = (
  filepaths : string[]
) : synt.ParseResult[] =>
  _.flatMap(filepaths, (filepath) => {
    const code = fs.readFileSync(filepath).toString()
    const node = astify(code, filepath)
    const root_node = node
    return parse_methods_and_classes(node, root_node, filepath)
  })

export = {
  find: find_similar_methods_and_classes
} as synt.Module.SimilarTS
