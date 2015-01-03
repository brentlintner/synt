latin = require "./../../../lib/parser/latin"
snippet = "Hello, world."
chai = require "chai"
expect = chai.expect

describe "integration :: parsing latin", ->
  it "can parse a simple english sentence", ->
    expect(f = latin.normalize(latin.tokenize(snippet)))
      .to.eql(["Hello", ",", "world", "."])
