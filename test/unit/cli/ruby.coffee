path = require "path"
mimus = require "mimus"
chai = require "chai"
shelljs = require "shelljs"
sinon_chai = require "./../../fixtures/sinon_chai"
expect = chai.expect
ruby = mimus.require "./../../../lib/cli/ruby", __dirname, []
ruby_cli = path.resolve(path.join __dirname, "..",
                       "..", "..", "bin", "cli-rb")

describe "unit :: cli/ruby", ->
  exec = null
  error = null

  beforeEach ->
    exec = mimus.stub()
    mimus.set ruby, "exec", exec

  afterEach mimus.restore

  describe "when bundle is not in PATH", ->
    it "errors out", ->
      mimus.stub shelljs, "which"
      error = mimus.stub()
      mimus.set ruby, "error", error

      shelljs.which
        .withArgs "bundle"
        .returns false

      ruby.compare {}

      error.should.have.been.called
      exec.should.not.have.been.called

  it "properly references ruby script", ->
    ruby.compare {}
    exec.should.have.been.calledWith(ruby_cli)

  it "sets -s option", ->
    ruby.compare stringCompare: true
    exec.should.have.been.called
    expect(exec.args[0][0]).to.match new RegExp " -s "

  it "sets -m option", ->
    opts = {}
    opts["min-threshold"] = 40
    ruby.compare opts
    exec.should.have.been.called
    expect(exec.args[0][0]).to.match new RegExp " -m 40 "

  it "sets -n option", ->
    ruby.compare ngram: "3..5"
    exec.should.have.been.called
    expect(exec.args[0][0]).to.match new RegExp " -n 3..5 "

  it "sets -a option", ->
    ruby.compare algorithm: "foo"
    exec.should.have.been.called
    expect(exec.args[0][0]).to.match new RegExp " -a foo "

  describe "when comparing strings", ->
    it "sets -c", ->
      ruby.compare compare: "foo", stringCompare: true
      exec.should.have.been.called
      expect(exec.args[0][0]).to.match new RegExp " -s "
      expect(exec.args[0][0]).to.match new RegExp " -c \"foo\" "

    it "sets -t", ->
      ruby.compare to: "bar", stringCompare: true
      exec.should.have.been.called
      expect(exec.args[0][0]).to.match new RegExp " -s "
      expect(exec.args[0][0]).to.match new RegExp " -t \"bar\" "

  describe "when comparing files", ->
    it "sets -c to an absolute path (based on cwd)", ->
      mimus.stub process, "cwd"
      process.cwd.returns "/cwd"

      ruby.compare compare: "foo"

      exec.should.have.been.called
      expect(exec.args[0][0]).to.not.match new RegExp " -s "
      expect(exec.args[0][0]).to.match new RegExp " -c \"/cwd/foo\" "

    it "sets -t to an absolute path (based on cwd)", ->
      mimus.stub process, "cwd"
      process.cwd.returns "/cwd"

      ruby.compare to: "bar"

      exec.should.have.been.called
      expect(exec.args[0][0]).to.not.match new RegExp " -s "
      expect(exec.args[0][0]).to.match new RegExp " -t \"/cwd/bar\" "

