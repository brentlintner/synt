mimus = require "mimus"
chai = require "chai"
shelljs = require "shelljs"
commander = require "commander"
logger = require "./../../lib/logger"
similar = require "./../../lib/similar"
pkg = require "./../../package"
sinon_chai = require "./../fixtures/sinon_chai"
expect = chai.expect
ruby_cli = require "./../../lib/cli/ruby"
haskell_cli = require "./../../lib/cli/haskell"
cli = mimus.require "./../../lib/cli", __dirname, []

describe "unit :: cli", ->
  argv = ["node", "script"]
  log = null
  err = null

  beforeEach ->
    mimus.stub similar, "compare"
    log = mimus.get cli, "log"
    mimus.stub log, "info"
    err = mimus.stub()
    mimus.set cli, "error", err

  afterEach mimus.restore

  describe "interpreting process argv", ->
    it "logs help without any errors", ->
      # TODO this is weird- logs help, but commander
      #      gets "error: unknown option -h"
      mimus.stub console, "log"
      mimus.stub process.stdout, "write"
      mimus.stub process.stderr, "write"
      mimus.stub process, "exit"
      cli.interpret argv.concat ["-h"]
      process.stdout.write.restore()
      process.stderr.write.restore()
      console.log.should.have.been.called
      console.log.restore()

    it "logs the similarity value to console", ->
      similar.compare.callsArgWith 1, null, 40
      cli.interpret argv
      log.info.should.have.been.called
      expect(log.info.args[0][0]).to.match /40%/

    describe "when similar calls back with an error", ->
      it "calls an error", ->
        similar.compare.callsArgWith 1, "some error"
        cli.interpret argv
        err.should.have.been.calledWith "some error"

    describe "when a threshold is reached", ->
      it "calls an error", ->
        similar.compare.callsArgWith 1, null, 40
        cli.interpret argv.concat ["-m", "60"]
        err.should.have.been.called
        expect(err.args[0][0]).to.match /threshold.*60%/

    describe "shelling out to haskell", ->
      it "calls the sub script compare method", ->
        mimus.stub haskell_cli, "compare"
        cli.interpret argv.concat ["-l", "hs"]
        haskell_cli.compare.should.have.been.calledWith commander
        similar.compare.should.not.have.been.called

    describe "shelling out to ruby", ->
      it "calls the sub script compare method", ->
        mimus.stub ruby_cli, "compare"
        cli.interpret argv.concat ["-l", "rb"]
        ruby_cli.compare.should.have.been.calledWith commander
        similar.compare.should.not.have.been.called
