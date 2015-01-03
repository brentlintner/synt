# See: http://en.wikipedia.org/wiki/Jaccard_index

# TODO: look into better perf here (less memory consumption?)

_ = require "lodash"
logger = require "./../logger"
log = logger.create "jaccard"

jaccard = (src, cmp) ->
  a = _.uniq src
  b = _.uniq cmp
  i = _.intersection a, b
  u = _.union a, b
  i.length / u.length * 100

module.exports =
  compare: jaccard
