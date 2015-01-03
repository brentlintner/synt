child_process = require "child_process"
path = require "path"
chai = require "chai"
sinon_chai = require "./../fixtures/sinon_chai"
pkg = require "./../../package"
synt_cli = require "./../../lib/cli"
synt_cli_bin = path.resolve path.join(__dirname, "..", "..", "bin", "cli")
expect = chai.expect

describe "system :: cli", ->
  describe "cli", ->
    argv = ["node", "script"]

    it "can call the cli as a user would", (done) ->
      this.slow 500

      child_process.exec synt_cli_bin + " --help",
        (error, stdout, stderr) ->
          expect(error).not.to.be.ok
          done()

    it "can compare two strings", (done) ->
      this.slow 500

      cmd = synt_cli_bin +
              " -s " +
              " -c \"x = x ^ 2\" " +
              " -t \"x = x * 2\""

      child_process.exec cmd,
        (error, stdout, stderr) ->
          expect(error).not.to.be.ok
          expect(stdout).to.match /60%/
          done()

    it "can compare two files", (done) ->
      this.slow 500

      cmd = synt_cli_bin +
        " -c ../fixtures/compare-cs-similar-a.coffee" +
        " -t ../fixtures/compare-cs-similar-b.coffee" +
        " -l coffee"

      child_process.exec cmd,
        cwd: __dirname,
        (error, stdout, stderr) ->
          expect(error).not.to.be.ok
          expect(stdout).to.match /80%/
          done()

    it "prints the version", (done) ->
      this.slow 500

      cmd = synt_cli_bin + " -V"

      child_process.exec cmd,
        (error, stdout, stderr) ->
          expect(error).not.to.be.ok
          expect(stdout).to.match new RegExp pkg.version
          done()

    it "exits with a minimum threshold", (done) ->
      this.slow 500

      cmd = synt_cli_bin +
        " -c ../fixtures/compare-cs-similar-a.coffee" +
        " -t ../fixtures/compare-cs-similar-b.coffee" +
        " -l coffee" +
        " -m 90"

      child_process.exec cmd,
        cwd: __dirname,
        (error, stdout, stderr) ->
          expect(error).to.be.ok
          expect(error.code).to.eql 1
          expect(stdout).to.match /threshold.*90%/
          done()

    # TODO
    #xit "can compare ruby files", ->
    #xit "can compare haskell files", ->
