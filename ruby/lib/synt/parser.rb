require 'ripper'
require 'manowar'

define 'Synt'

module Synt::Parser
  extend self

  def parse string
    Ripper.tokenize string
  end
end
