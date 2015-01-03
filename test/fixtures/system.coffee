path = require "path"
fs = require "fs"
synt = require "./../../lib"
logger = require "./../../lib/logger"
log = logger.create "system tests"

c_js_similar_a = path.resolve __dirname, "compare-js-similar_a.js"
c_js_similar_b = path.resolve __dirname, "compare-js-similar_b.js"
c_js_dissimilar_a = path.resolve __dirname, "compare-js-dissimilar_a.js"
c_js_dissimilar_b = path.resolve __dirname, "compare-js-dissimilar_b.js"

c_cs_similar_a = path.resolve __dirname, "compare-cs-similar-a.coffee"
c_cs_similar_b = path.resolve __dirname, "compare-cs-similar-b.coffee"
c_cs_dissimilar_a = path.resolve __dirname, "compare-cs-dissimilar-a.coffee"
c_cs_dissimilar_b = path.resolve __dirname, "compare-cs-dissimilar-b.coffee"

c_js_dupe = "function (a) { console.log(\"foo\") }"
c_cs_dupe = "foo = (a, b) -> a + b"

c_latin_dupe = "Hello, world!"
c_latin_similar_a = path.resolve __dirname, "l1.txt"
c_latin_similar_b = path.resolve __dirname, "l2.txt"
c_latin_dissimilar_a = "This is the sentence. With no other words."
c_latin_dissimilar_b = "This is a sentence. Where does it go?"

test_for = (a, b, lang, ngram, is_string, fails) ->
  assert = (percent, type) ->
    if fails Math.floor percent
      throw Error "#{type} percent is %#{percent}?"

  cmp = (algo, cb) ->
    synt.compare
      compare: a
      to: b
      language: lang
      ngram: ngram || 1
      algorithm: algo,
      stringCompare: is_string
    , cb

  cmp "jaccard", (err, sim) ->
    throw Error "jaccard return value is #{sim}" if !sim
    log.info "default (jaccard): %#{Math.floor(sim)}"
    assert sim, "jaccard"

  cmp "tanimoto", (err, sim) ->
    throw Error "tanimoto return value is #{sim}" if !sim
    log.info "tanimoto: %#{Math.floor(sim)}"
    assert sim, "tanimoto"

module.exports =
  test_for: test_for
  c_js_similar_a: c_js_similar_a
  c_js_similar_b: c_js_similar_b
  c_js_dissimilar_a: c_js_dissimilar_a
  c_js_dissimilar_b: c_js_dissimilar_b
  c_cs_similar_a: c_cs_similar_a
  c_cs_similar_b: c_cs_similar_b
  c_cs_dissimilar_a: c_cs_dissimilar_a
  c_cs_dissimilar_b: c_cs_dissimilar_b
  c_js_dupe: c_js_dupe
  c_cs_dupe: c_cs_dupe
  c_latin_dupe: c_latin_dupe
  c_latin_similar_a: c_latin_similar_a
  c_latin_similar_b: c_latin_similar_b
  c_latin_dissimilar_a: c_latin_dissimilar_a
  c_latin_dissimilar_b: c_latin_dissimilar_b
