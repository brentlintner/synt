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

    on 'c=', 'compare=',        'File to compare to something.'
    on 't=', 'to=',             'File to compare against.'
    on 's',  'string-compare',  'Compare strings instead of files.'
    on 'a=', 'algorithm=',      'Similarity algorithm
                                 [default=jaccard,tanimoto].'
    on 'n=', 'ngram=',          'Specify what ngrams are generated and used for
                                 comparing token sequences.
                                 [default=1,2,4..5,10,...,all]'
    on 'm=', 'min-threshold=',  'Similarity threshold % (ex: -m 70)
                                 to exit with error.'

    on '-v', 'version',         'Print the version.' do
      puts Synt::VERSION
      exit 0
    end
  }
end
