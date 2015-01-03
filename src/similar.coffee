fs = require "fs"
path = require "path"
logger = require "./logger"
ngram = require "./similar/ngram"
log = logger.create "similar"

parsers =
  js: require "./parser/javascript"
  coffee: require "./parser/coffeescript"
  latin: require "./parser/latin"

algorithms =
  jaccard: require "./similar/jaccard"
  tanimoto: require "./similar/tanimoto"

parse_data = (is_string, value) ->
  if is_string then value
  else fs.readFileSync value, "utf-8"

similar = (opts, cb) ->
  return cb "no compare property provided" if !opts.compare
  return cb "no to property provided" if !opts.to

  src = parse_data opts.stringCompare, opts.compare
  cmp = parse_data opts.stringCompare, opts.to

  # TODO: put defaults in conf
  algorithm = opts.algorithm || "jaccard"
  language = opts.language || "js"

  if algorithms[algorithm]
    compare = algorithms[algorithm].compare
  else return cb "unknown algorithm"

  if parsers[language]
    parser = parsers[language]
  else return cb "unknown language parser"

  [n_start, n_end] = ngram.range opts.ngram

  src_t = parser.normalize parser.tokenize src
  cmp_t = parser.normalize parser.tokenize cmp

  a = ngram.generate src_t, n_start, n_end
  b = ngram.generate cmp_t, n_start, n_end

  sim = (compare a, b).toFixed 2

  cb null, sim

module.exports =
  compare: similar
