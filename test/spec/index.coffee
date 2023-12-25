chai = require "chai"
library = require "./../../lib"
expect = chai.expect

describe "unit :: library", ->
  describe "when required", ->
    it "exports the library", ->
      expect(library).to.have.property("compare")
      expect(library).to.have.property("print")
      expect(library).to.have.property("DEFAULT_NGRAM_LENGTH")
      expect(library).to.have.property("DEFAULT_THRESHOLD")
      expect(library).to.have.property("DEFAULT_TOKEN_LENGTH")
