require 'slop'
require 'manowar'
require_relative 'version'

define 'Synt'

module Synt::CLI
  extend self

  def parse
    Slop.parse help: true, &API
  end

  private

  API = proc {
    banner 'Usage: synt.rb [options]'

    on 't=', 'tokenize=', 'file or string to tokenize'
    on 'c=', 'compare=', 'File or String to compare to something.'
    on 't=', 'to=', 'File or String to compare against.'
    on 'a=', 'algorithm=', 'Similarity algorithm [default=jaccard,tanimoto].'
    on 'n=', 'ngram=', 'Specify what ngrams are generated and used for
                       comparing token sequences.
                       [default=1,2,4..5,10,...,all]'
    on 'd=', 'threshold=', 'Similarity threshold and exit with error.'

    on '-v', 'version', 'Print the version.' do
      puts Synt::VERSION
      exit 0
    end
  }
end
