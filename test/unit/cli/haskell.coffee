path = require "path"
mimus = require "mimus"
chai = require "chai"
shelljs = require "shelljs"
sinon_chai = require "./../../fixtures/sinon_chai"
expect = chai.expect
haskell = mimus.require "./../../../lib/cli/haskell", __dirname, []
haskell_cli = path.resolve(path.join __dirname, "..",
                           "..", "..", "bin", "cli-hs")

describe "unit :: cli/haskell", ->
  exec = null
  error = null

  beforeEach ->
    exec = mimus.stub()
    mimus.set haskell, "exec", exec

  afterEach mimus.restore

  describe "when cabal is not in PATH", ->
    it "errors out", ->
      mimus.stub shelljs, "which"
      error = mimus.stub()
      mimus.set haskell, "error", error

      shelljs.which
        .withArgs "cabal"
        .returns false

      haskell.compare {}

      error.should.have.been.called
      exec.should.not.have.been.called

  it "properly references haskell script", ->
    haskell.compare {}
    exec.should.have.been.calledWith(haskell_cli)

  it "sets -s option", ->
    haskell.compare stringCompare: true
    exec.should.have.been.called
    expect(exec.args[0][0]).to.match new RegExp " -s "

  it "sets -m option", ->
    opts = {}
    opts["min-threshold"] = 40
    haskell.compare opts
    exec.should.have.been.called
    expect(exec.args[0][0]).to.match new RegExp " -m 40 "

  it "sets -n option", ->
    haskell.compare ngram: "3..5"
    exec.should.have.been.called
    expect(exec.args[0][0]).to.match new RegExp " -n 3..5 "

  it "sets -a option", ->
    haskell.compare algorithm: "foo"
    exec.should.have.been.called
    expect(exec.args[0][0]).to.match new RegExp " -a foo "

  describe "when comparing strings", ->
    it "sets -c", ->
      haskell.compare compare: "foo", stringCompare: true
      exec.should.have.been.called
      expect(exec.args[0][0]).to.match new RegExp " -s "
      expect(exec.args[0][0]).to.match new RegExp " -c \"foo\" "

    it "sets -t", ->
      haskell.compare to: "bar", stringCompare: true
      exec.should.have.been.called
      expect(exec.args[0][0]).to.match new RegExp " -s "
      expect(exec.args[0][0]).to.match new RegExp " -t \"bar\" "

  describe "when comparing files", ->
    it "sets -c to an absolute path (based on cwd)", ->
      mimus.stub process, "cwd"
      process.cwd.returns "/cwd"

      haskell.compare compare: "foo"

      exec.should.have.been.called
      expect(exec.args[0][0]).to.not.match new RegExp " -s "
      expect(exec.args[0][0]).to.match new RegExp " -c \"/cwd/foo\" "

    it "sets -t to an absolute path (based on cwd)", ->
      mimus.stub process, "cwd"
      process.cwd.returns "/cwd"

      haskell.compare to: "bar"

      exec.should.have.been.called
      expect(exec.args[0][0]).to.not.match new RegExp " -s "
      expect(exec.args[0][0]).to.match new RegExp " -t \"/cwd/bar\" "

