js = require "./../../../lib/parser/javascript"
snippet = "function (foo) {}"
chai = require "chai"
expect = chai.expect

describe "integration :: parsing javascript", ->
  it "can parse a simple snippet", ->
    expect(js.normalize(js.tokenize(snippet)))
      .to.eql(["function", "(", "foo", ")", "{", "}"])
