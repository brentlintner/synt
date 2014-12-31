path = require "path"
wrench = require "wrench"
Mocha = require "mocha"
_ = require "lodash"
specs = path.join __dirname, "..", "test"

find = (spec_type) ->
  f = wrench
    .readdirSyncRecursive path.join(specs, spec_type)
    .filter (p) -> /\.js/.test p
    .map (p) -> path.resolve (path.join specs, spec_type, p)

all_specs = ->
  find("unit")
    .concat find("integration")
    .concat find("system")

run = (type) ->
  runner = new Mocha
    ui: "bdd"
    reporter: "spec"
    timeout: 10000

  runner.files = all_specs()

  runner.run process.exit

module.exports =
  run: run
