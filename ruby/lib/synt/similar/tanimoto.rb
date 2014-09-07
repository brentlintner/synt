#  This is an (apparently) generalized jaccard algorithm, with its unique uses.

#  See: http://en.wikipedia.org/wiki/Talk%3AJaccard_index#Tanimoto_coefficient

#  I understand that since data is ultimately
#  reduced to unique lists of comparable, scalar data, the equation can
#  be further generalized as a function of cardinal lengths.
#  This may or may not be correct (in theory)!
#  I am still unsure if this works for multisets.
#  The output seem to be as expected, though.
require 'manowar'

define 'Synt::Similar'

module Synt::Similar::Tanimoto
  extend self

  def compare src, cmp
    a = src.uniq
    b = cmp.uniq
    i = a & b

    i.length.to_f / (a.length.to_f + b.length.to_f - i.length.to_f) * 100
  end
end
