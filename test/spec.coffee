fs = require "fs"
path = require "path"
_ = require "lodash"
esprima = require "esprima"
mimus = require "mimus"
chai = require "chai"
sinon_chai = require "./fixtures/sinon_chai"
expect = chai.expect
similar = require "./../lib"
logger = require "./../lib/logger"
log = logger.create "testing"

read = (p) -> fs.readFileSync path.join(__dirname, p), "utf-8"

c_js_similar = require "./fixtures/compare-js-similar"
c_js_dissimilar = require "./fixtures/compare-js-dissimilar"

c_cs_similar_a = read "fixtures/compare-cs-similar-a.coffee"
c_cs_similar_b = read "fixtures/compare-cs-similar-b.coffee"
c_cs_dissimilar_a = read "fixtures/compare-cs-dissimilar-a.coffee"
c_cs_dissimilar_b = read "fixtures/compare-cs-dissimilar-b.coffee"

c_js_dupe = "function (a) { console.log(\"foo\") }"
c_cs_dupe = "foo = (a, b) -> a + b"

test_for = (a, b, lang, ngram, fails) ->
  assert = (percent, type) ->
    if fails Math.floor percent
      throw Error "#{type} percent is %#{percent}?"

  cmp = (algo) ->
    similar.compare
      compare: a
      to: b
      language: lang
      ngram: ngram || 1
      algorithm: algo

  sim_jac = cmp()
  sim_tan = cmp "tanimoto"
  sim_exp = cmp "experimental"

  throw Error "jaccard return value is #{sim_jac}" if !sim_jac
  throw Error "tanimoto return value is #{sim_tan}" if !sim_tan
  throw Error "experimental return value is #{sim_exp}" if !sim_exp

  log.info ""
  log.info "threshold: #{fails.toString().replace /\n\s*/g, ""}"
  log.info "default (jaccard): %#{Math.floor(sim_jac)}"
  log.info "tanimoto: %#{Math.floor(sim_tan)}"
  log.info "experimental: %#{Math.floor(sim_exp)}"

  assert sim_jac, "jaccard"
  assert sim_tan, "tanimoto"
  assert sim_exp, "experimental"

describe "logger", ->
  describe 'smoke tests', ->
    it 'can toggle verbose', ->
      logger.verbose true
      logger.verbose false

describe "similarity matching", ->
  before logger.quiet

  describe "smoke tests", ->
    it "errors out when no compare provided", ->
      mimus.stub process, "exit"
      similar.compare to: "fdff"
      process.exit.should.have.been.calledWith 1
      process.exit.restore()

    it "errors out when no to provided", ->
      mimus.stub process, "exit"
      similar.compare compare: "fdff"
      process.exit.should.have.been.calledWith 1
      process.exit.restore()

  describe "javascript", ->
    it "compares duplicate functions", ->
      test_for c_js_dupe,
               c_js_dupe,
               "js", "all",
               (p) -> p != 100

    it "compares a very similar function", ->
      test_for c_js_similar.a.toString(),
               c_js_similar.b.toString(),
               "js", 2,
               (p) -> p < 70

    it "compares a very disimiliar function", ->
      test_for c_js_dissimilar.a.toString(),
               c_js_dissimilar.b.toString(),
               "js", 2,
               (p) -> p < 1 or p > 20

  describe "coffeescript", ->
    it "compares a duplicate function", ->
      test_for c_cs_dupe,
               c_cs_dupe,
               "coffee", null,
               (p) -> p != 100

    it "compares a very similiar function", ->
      test_for c_cs_similar_a,
               c_cs_similar_b,
               "coffee", 2,
               (p) -> p < 70

    it "compares a very dissimiliar function", ->
      test_for c_cs_dissimilar_a,
               c_cs_dissimilar_b,
               "coffee", 2,
               (p) -> p < 1 or p > 25

    it "compares a very dissimiliar function with an ngram range", ->
      test_for c_cs_dissimilar_a,
               c_cs_dissimilar_b,
               "coffee", "1..2",
               (p) -> p < 1 or p > 25
