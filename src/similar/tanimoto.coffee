###

  This is an (apparently) generalized jaccard algorithm, with its unique uses.

  See: http://en.wikipedia.org/wiki/Talk%3AJaccard_index#Tanimoto_coefficient

  I understand that since data is ultimately
  reduced to unique lists of comparable, scalar data, the equation can
  be further generalized as a function of cardinal lengths.

  This may or may not be correct (in theory)!
  I am still unsure if this works for multisets.
  The output seem to be as expected, though.

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
