esprima = require "esprima"
coffee = require "coffee-script"
_ = require "lodash"
logger = require "./logger"
error = require "./error"
log = logger.create "similar"
algorithms =
  jaccard: require "./similar/jaccard"
  tanimoto: require "./similar/tanimoto"
  experimental: require "./similar/experimental"

generate_ngrams = (arr, start = 1, end = arr.length) ->

  if end > arr.length
    start = end = 1
    log.warn "ngram end value exceeds length-
              setting start/end to: 1."

  return arr if start == end && start == 1 # short circuit

  sets = []

  for len in [start..end]
    arr.forEach (token, index) ->
      s_len = index + len

      if s_len <= arr.length
        sets.push arr[index...s_len].join ""

  sets

normalize_esprima_tokens = (token_list) ->
  token_list.map (t) -> t.value

normalize_coffee_tokens = (token_list) ->
  token_list
    .filter (t) -> t[0] != "TERMINATOR" &&
                   t[0] != "OUTDENT" &&
                   t[0] != "INDENT"
    .map (t) -> if /^[A-Z_]*$/.test t[0] then t[1] else t[0]


ngram_range = (ngram) ->
  is_range = /\.\./

  if !ngram
    [1, 1]
  else if is_range.test ngram
    n = ngram.split ".."
    [parseInt(n[0], 10), parseInt(n[1], 10)]
  else if ngram != "all"
    n = parseInt ngram, 10
    [n, n]
  else
    [null, null]

similar = (opts) ->
  if !opts.compare then error "no compare propery provided"
  if !opts.to then error "no to propery provided"

  src = opts.compare || ""
  cmp = opts.to || ""
  algorithm = opts.algorithm || "jaccard"
  language = opts.language || "js"
  compare = algorithms[algorithm].compare
  src_t = cmp_t = null
  [ngram_start, ngram_end] = ngram_range opts.ngram

  switch language
    when "js"
      src_t = normalize_esprima_tokens esprima.tokenize src
      cmp_t = normalize_esprima_tokens esprima.tokenize cmp
    when "coffee"
      src_t = normalize_coffee_tokens coffee.tokens src
      cmp_t = normalize_coffee_tokens coffee.tokens cmp

  compare generate_ngrams(src_t, ngram_start, ngram_end),
          generate_ngrams(cmp_t, ngram_start, ngram_end)

module.exports =
  compare: similar
