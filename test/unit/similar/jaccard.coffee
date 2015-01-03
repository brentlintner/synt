chai = require "chai"
expect = chai.expect
jaccard = require "./../../../lib/similar/jaccard"

describe "unit :: jaccard algorithm", ->
  it "does a simple calculation", ->
    a = [2, 3, 4]
    b = [3, 4, 5]
    expect(jaccard.compare a, b).to.eql 50
