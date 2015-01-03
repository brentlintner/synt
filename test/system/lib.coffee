chai = require "chai"
sinon_chai = require "./../fixtures/sinon_chai"
synt = require "./../../lib"
logger = require "./../../lib/logger"
system = require "./../fixtures/system"
expect = chai.expect

describe "system :: library", ->
  before logger.quiet

  describe "javascript", ->
    it "compares duplicate functions", ->
      system.test_for system.c_js_dupe,
                      system.c_js_dupe,
                      "js", "all", true,
                      (p) -> p != 100

    it "compares a very similar function", ->
      system.test_for system.c_js_similar_a,
                      system.c_js_similar_b,
                      "js", 2, false,
                      (p) -> p < 70

    it "compares a very disimiliar function", ->
      system.test_for system.c_js_dissimilar_a,
                      system.c_js_dissimilar_b,
                      "js", 2, false,
                      (p) -> p < 1 or p > 20

  describe "coffeescript", ->
    it "compares a duplicate function", ->
      system.test_for system.c_cs_dupe,
                      system.c_cs_dupe,
                      "coffee", null, true,
                      (p) -> p != 100

    it "compares a very similiar function", ->
      system.test_for system.c_cs_similar_a,
                      system.c_cs_similar_b,
                      "coffee", 2, false,
                      (p) -> p < 70

    it "compares a very dissimiliar function", ->
      system.test_for system.c_cs_dissimilar_a,
                      system.c_cs_dissimilar_b,
                      "coffee", 2, false,
                      (p) -> p < 1 or p > 25

    it "compares a very dissimiliar function with an ngram range", ->
      system.test_for system.c_cs_dissimilar_a,
                      system.c_cs_dissimilar_b,
                      "coffee", "1..2", false,
                      (p) -> p < 1 or p > 25

  describe "latin", ->
    it "compares a duplicate snippet", ->
      system.test_for system.c_latin_dupe,
                      system.c_latin_dupe,
                      "latin", null, true,
                      (p) -> p != 100

    it "compares a very similiar snippet", ->
      system.test_for system.c_latin_similar_a,
                      system.c_latin_similar_b,
                      "latin", 2, false,
                      (p) -> p < 70

    it "compares a very dissimiliar snippet", ->
      system.test_for system.c_latin_dissimilar_a,
                      system.c_latin_dissimilar_b,
                      "latin", 2, true,
                      (p) -> p < 1 or p > 25

    it "compares a very dissimiliar snippet with an ngram range", ->
      system.test_for system.c_latin_dissimilar_a,
                      system.c_latin_dissimilar_b,
                      "latin", "1..2", true,
                      (p) -> p < 1 or p > 25
