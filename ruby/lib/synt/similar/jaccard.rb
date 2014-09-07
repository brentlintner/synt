#  See: http://en.wikipedia.org/wiki/Jaccard_index
require 'manowar'

define 'Synt::Similar'

module Synt::Similar::Jaccard
  extend self

  def compare src, cmp
    a = src.uniq
    b = cmp.uniq
    i = a & b
    u = a | b
    i.length.to_f / u.length.to_f * 100
  end
end
