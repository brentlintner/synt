mimus = require "mimus"
sinon_chai = require "./../../fixtures/sinon_chai"
chai = require "chai"
ngram = mimus.require "./../../../lib/similar/ngram", __dirname, []
expect = chai.expect

describe "unit :: ngram utils", ->
  describe "creating a ngram range (tuple) from a string", ->
    it "returns [1, 1] when given a falsy value", ->
      expect(ngram.range()).to.eql [1, 1]

    it "returns [x, y] when given a range string", ->
      expect(ngram.range("1..4")).to.eql [1, 4]

    it "returns [x, x] when given a non-range string", ->
      expect(ngram.range("3")).to.eql [3, 3]

    # TODO: not the best feature... (makes callers aware of this special case..)
    #       probably should give list like in Haskell implementation
    it "returns [null, null] when given 'all' string", ->
      expect(ngram.range("all")).to.eql [null, null]

  # TODO: could be a better API for this.. take a tuple?
  describe "generating ngrams", ->
    list = ["1", "2", "3", "4"]

    it "can generate all ngrams", ->
      expect(ngram.generate list)
        .to.eql [
          "1", "2", "3", "4",
          "12", "23", "34",
          "123", "234", "1234"
        ]

    it "can generate a unigram", ->
      expect(ngram.generate list, 1, 1)
        .to.eql ["1", "2", "3", "4"]

    it "can generate a bigram", ->
      expect(ngram.generate list, 2, 2)
        .to.eql ["12", "23", "34"]

    it "can generate a trigram", ->
      expect(ngram.generate list, 3, 3)
        .to.eql ["123", "234"]

    it "can generate all bigrams and trigrams", ->
      expect(ngram.generate list, 2, 3)
        .to.eql ["12", "23", "34", "123", "234"]

    # TODO: not the most succinct behaviour..
    describe "when end is greater than the length of the list", ->
      log = null

      beforeEach ->
        log = mimus.get ngram, "log"
        mimus.stub log, "warn"

      it "logs a warning notice to the console", ->
        ngram.generate list, 3, 10
        log.warn.should.have.been.called

      it "sets start and end to 1", ->
        expect(ngram.generate list, 3, 10)
          .to.eql ["1", "2", "3", "4"]
