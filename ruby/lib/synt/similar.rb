require 'manowar'
require_relative 'parser'
require_relative 'similar/jaccard'
require_relative 'similar/tanimoto'

define 'Synt'

module Synt::Similar
  extend self

  def determine string_or_file
    if File.exists? string_or_file
      IO.read string_or_file
    else
      string_or_file || ''
    end
  end

  def compare opts
    error 'no compare propery provided' unless opts[:compare]
    error 'no to propery provided' unless opts[:to]

    src = determine opts[:compare]
    cmp = determine opts[:to]
    algorithm = algorithms[(opts[:algorithm] || 'jaccard').to_sym]
    n_start, n_end = ngram_range opts[:ngram]
    src_t = normalize_ripper_tokens Synt::Parser.parse(src)
    cmp_t = normalize_ripper_tokens Synt::Parser.parse(cmp)

    a = generate_ngrams src_t, n_start, n_end
    b = generate_ngrams cmp_t, n_start, n_end

    sim = algorithm.compare a, b

    sim.to_f.round 2
  end

  private

  def algorithms
    { jaccard: Jaccard, tanimoto: Tanimoto }
  end

  def generate_ngrams arr, start, nend
    nend = arr.length unless nend
    start = 1 unless start

    if nend > arr.length
      start = nend = 1
      puts 'ngram end value exceeds max length- setting start/end to: 1'
    end

    return arr if start == nend && start == 1 # short circuit

    sets = []

    (start..nend).to_a.each_index do |n_len|
      arr.each_index do |index|
        s_len = index + n_len
        sets.push arr[index, s_len].join('') if s_len <= arr.length
      end
    end

    sets
  end

  def ngram_range ngram
    is_range = /\.\./

    if !ngram
      return 1, 1
    elsif ngram =~ is_range
      n = ngram.split '..'
      return n[0].to_i, n[1].to_i
    elsif ngram != 'all'
      n = ngram.to_i
      return n, n
    else
      return nil, nil
    end
  end

  def normalize_ripper_tokens tokens
    tokens.select { |t| t && t !~ /^\s*$/ }
  end

  def error msg
    puts msg
    exit 1
  end
end
