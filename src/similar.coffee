fs = require "fs"
logger = require "./logger"
error = require "./error"
log = logger.create "similar"
js = require "./parser/javascript"
coffee = require "./parser/coffeescript"
algorithms =
  jaccard: require "./similar/jaccard"
  tanimoto: require "./similar/tanimoto"
  experimental: require "./similar/experimental"

determine = (file_or_string) ->
  if fs.existsSync file_or_string
  then fs.readFileSync file_or_string, "utf-8"
  else file_or_string

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
  ngram_type = "list" # or "tree"
  algorithm = opts.algorithm || "jaccard"
  language = opts.language || "js"
  compare = algorithms[algorithm].compare
  src_t = cmp_t = null
  [n_start, n_end] = ngram_range opts.ngram

  switch language
    when "js"
      src_t = js.normalize js.tokenize determine src
      cmp_t = js.normalize js.tokenize determine cmp
    when "coffee"
      src_t = coffee.normalize coffee.tokenize determine src
      cmp_t = coffee.normalize coffee.tokenize determine cmp

  a = generate_ngrams src_t, n_start, n_end
  b = generate_ngrams cmp_t, n_start, n_end
  sim = compare a, b

  sim.toFixed 2

module.exports =
  compare: similar
