path = require "path"
Mocha = require "mocha"

run = (type) ->
  runner = new Mocha
    ui: "bdd"
    reporter: "spec"

  runner.files = [ path.join __dirname, "spec.js" ]

  runner.run process.exit

module.exports =
  run: run
