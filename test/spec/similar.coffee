sinon_chai = require "./../helpers/sinon_chai"
chai = require "chai"
similar = require "./../../lib/similar"
expect = chai.expect

describe "unit :: similar", ->
  describe "when no args/opts are provided", ->
    it "does not die", ->
      similar.compare()
