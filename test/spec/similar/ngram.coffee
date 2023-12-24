sinon_chai = require "./../../helpers/sinon_chai"
chai = require "chai"
ngram = require "./../../../lib/similar/ngram"
expect = chai.expect

describe "unit :: ngram", ->
  describe "generating ngrams", ->
    list = ["1", "2", "3", "4"]

    it "defaults to 1 if larger than array length", ->
      expect(ngram.generate list, 200)
        .to.eql ["1", "2", "3", "4"]

    it "can generate a unigram by default", ->
      expect(ngram.generate list)
        .to.eql ["1", "2", "3", "4"]

    it "can generate a unigram", ->
      expect(ngram.generate list, 1)
        .to.eql ["1", "2", "3", "4"]

    it "can generate a bigram", ->
      expect(ngram.generate list, 2)
        .to.eql ["12", "23", "34"]

    it "can generate a trigram", ->
      expect(ngram.generate list, 3)
        .to.eql ["123", "234"]
