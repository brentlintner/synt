mimus = require "mimus"
error = mimus.require "./../../lib/error", __dirname, []

describe "unit :: error", ->
  describe "exit", ->
    afterEach mimus.restore

    it "logs to the console", ->
      mimus.stub process, "exit"
      log = mimus.get error, "log"
      mimus.stub log, "error"

      error_msg = "i haz an issue!"
      error error_msg

      log.error.should.have.been.calledWith error_msg

      process.exit.restore()

    it "exits the process", ->
      mimus.stub process, "exit"
      log = mimus.get error, "log"
      mimus.stub log, "error"

      error "with some message"

      process.exit.should.have.been.calledWith 1
      process.exit.restore()
