path = require "path"
Mocha = require "mocha"

run = (type) ->
  runner = new Mocha
    ui: "bdd"
    reporter: "dot"
    timeout: 10000

  runner.files = [ path.join __dirname, "spec.js" ]

  runner.run process.exit

module.exports =
  run: run
