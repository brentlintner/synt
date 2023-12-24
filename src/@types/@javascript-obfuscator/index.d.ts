declare module "@javascript-obfuscator/escodegen" {
  import * as ec from "escodegen"
  import * as et from "estree"

  export function generate(ast : et.Node, options ?: ec.GenerateOptions) : string
}
