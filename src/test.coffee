fs = require "fs"
path = require "path"
ts_test_file = path.join __dirname, "..", "test", "fixtures", "test_ts.ts"
ts_services_path = process.cwd() +
  '/node_modules/typescript/bin/typescriptServices.js'

source = fs.readFileSync ts_test_file, "utf-8"

eval(fs.readFileSync(ts_services_path, "utf-8"))

console.log(Object.keys(TypeScript.Parser))
syntaxTree = TypeScript.Parser.parse(path.basename(ts_test_file),
              TypeScript.SimpleText.fromString(source), true)

sU = syntaxTree._sourceUnit

sU.moduleElements.forEach (i) ->
  console.log i.name || i.expression
  console.log()
  console.log()
  console.log()
  console.log()
  i.moduleElements.forEach (s) ->
    console.log(s)
