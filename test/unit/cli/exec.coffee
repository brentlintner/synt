path = require "path"
child_process = require "child_process"
mimus = require "mimus"
sinon = require "sinon"
sinon_chai = require "./../../fixtures/sinon_chai"
chai = require "chai"
exec = mimus.require "./../../../lib/cli/exec", __dirname, []
project_root = path.resolve(path.join __dirname, "..", "..", "..")
expect = chai.expect

describe "unit :: exec", ->
  cmd = "some cmd"
  cb = null
  error = null
  stdout = "stdout"
  stderr = null

  beforeEach ->
    cb = mimus.stub()
    mimus.stub child_process, "exec"
    mimus.stub process.stdout, "write"

  afterEach mimus.restore

  it "sets the cwd as the top level project root", ->
    exec cmd
    expect(child_process.exec.args[0][1].cwd).to.eql project_root

  it "passes along the node script's env", ->
    exec cmd
    expect(child_process.exec.args[0][1].env).to.eql process.env

  it "logs stdout to console", ->
    child_process.exec.callsArgWith 2, error, stdout, stderr
    exec cmd
    process.stdout.write
      .should.have.been.calledWith stdout

  it "logs any stderr to console if there are any", ->
    stderr = "stderr"
    child_process.exec.callsArgWith 2, error, stdout, stderr
    exec cmd
    process.stdout.write
      .should.have.been.calledWith stderr

  it "calls back with error, stdout and stderr", ->
    cb = mimus.stub()
    child_process.exec.callsArgWith 2, error, stdout, stderr
    exec cmd, cb
    cb.should.have.been.calledWith error, stdout, stderr

  describe "if there was an actual error", ->
    it "logs the error", ->
      error = "some error"
      log = mimus.get exec, "log"
      mimus.stub log, "error"
      child_process.exec.callsArgWith 2, error, stdout, stderr

      exec cmd, cb

      log.error.should.have.been.calledWith error
