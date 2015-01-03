coffee = require "./../../../lib/parser/coffeescript"
snippet = "(foo) ->"
chai = require "chai"
expect = chai.expect

describe "integration :: parsing coffeescript", ->
  it "can parse a simple snippet", ->
    expect(coffee.normalize(coffee.tokenize(snippet)))
      .to.eql(["(", "foo", ")", "->"])
