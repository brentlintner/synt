mimus = require "mimus"
chai = require "chai"
sinon_chai = require "./../fixtures/sinon_chai"
similar = require "./../../lib/similar"
expect = chai.expect

should_callback_with_error = (opts, regex, cb) ->
  opts.stringCompare = true
  similar.compare opts, (err, sim) ->
    expect(err).to.be.ok
    expect(err).to.match regex
    cb()

describe "unit :: similar", ->
  describe "compare", ->
    describe "when no compare property is provided", ->
      it "should callback with an error", (done) ->
        should_callback_with_error
          to: "string"
        , /compare property/i, done

    describe "when no to property is provided", ->
      it "should callback with an error", (done) ->
        should_callback_with_error
          compare: "string"
        , /to property/i, done

    describe "when an unknown language extension is given", ->
      it "should callback with an error", (done) ->
        should_callback_with_error
          compare: "string"
          to: "string"
          language: "allonge"
        , /unknown language/i, done

    describe "when an unknown algorithm is given", ->
      it "should callback with an error", (done) ->
        should_callback_with_error
          compare: "string"
          to: "string"
          algorithm: "dave matthews"
        , /unknown algorithm/i, done
