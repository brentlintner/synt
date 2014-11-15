fs = require "fs"
path = require "path"
ts_test_file = path.join __dirname, "..", "..", "test",
                        "fixtures", "test_ts.ts"
ts_services_path = path.join __dirname, "..",
                    "..", "node_modules", "typescript",
                    "bin", "typescriptServices.js"

# "require" in TypeScript
eval fs.readFileSync(ts_services_path, "utf-8")

normalize_typescript_tokens = (list) ->
  list.map (t) -> t

walk = (list, arr=[]) ->
  walk list.moduleElements, arr

tokenize_typescript = (string) ->
  syntaxTree = TypeScript.Parser.parse(path.basename(ts_test_file),
                TypeScript.SimpleText.fromString(string), true)
  console.log syntaxTree._sourceUnit
  syntaxTree

module.exports =
  normalize: normalize_typescript_tokens
  tokenize: tokenize_typescript
