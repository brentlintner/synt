require_relative 'synt/cli'
require_relative 'synt/similar'

module Synt
  extend self

  def new
    # TODO: move to CLI? this is lib.
    opts = CLI.parse
    diff = Similar.compare opts

    puts "Inputs are #{diff}% similar."

    if opts.threshold? && diff < opts["min-threshold"].to_f
      puts "Similarity threshold of #{opts["min-threshold"]}% hit."
      exit 1
    end
  end
end
