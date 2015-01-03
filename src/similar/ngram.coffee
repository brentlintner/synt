logger = require "./../logger"
log = logger.create "ngram"

generate_ngrams = (arr, start = 1, end = arr.length) ->
  if end > arr.length
    start = end = 1
    log.warn "end value exceeds length- setting start/end to: 1."

  return arr if start == end && start == 1

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

module.exports =
  generate: generate_ngrams
  range: ngram_range
