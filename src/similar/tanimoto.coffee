###
  See: http://en.wikipedia.org/wiki/Talk%3AJaccard_index#Tanimoto_coefficient
###

_ = require "lodash"
logger = require "./../logger"
log = logger.create "tanimoto"

tanimoto = (src, cmp) ->
  a = _.uniq src
  b = _.uniq cmp
  i = _.intersection a, b
  i_len = i.length
  ap = a.length
  bp = b.length
  i_len / (ap + bp - i_len) * 100

module.exports =
  compare: tanimoto
