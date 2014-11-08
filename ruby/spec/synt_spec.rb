require_relative './spec_helper'
require_relative './../lib/synt/similar'

describe Synt::Similar do
  subject { Synt::Similar }

  algorithms = ['jaccard', 'tanimoto']
  ngram_types = [1, '1..3', 'all']

  let(:duplicate_path) { 'spec/fixtures/compare-rb-duplicate.rb' }
  let(:similar_a_path) { 'spec/fixtures/compare-rb-similar-a.rb' }
  let(:similar_b_path) { 'spec/fixtures/compare-rb-similar-b.rb' }
  let(:dissimilar_a_path) { 'spec/fixtures/compare-rb-dissimilar-a.rb' }
  let(:dissimilar_b_path) { 'spec/fixtures/compare-rb-dissimilar-b.rb' }

  context 'cli' do
    context 'comparing things' do
      context 'that are Files' do
        before do
          allow(File).to receive(:exists?).and_return(true)
          expect(IO).to receive(:read).and_return("42").twice
        end

        it 'read both files from the file system' do
          subject.compare compare: "file/path.rb", to: "file/path2"
        end
      end

      context 'that are Strings' do
        before do
          allow(File).to receive(:exists?).and_return(false)
          expect(IO).to_not receive(:read)
        end

        it 'should not read any files' do
          subject.compare compare: "file/path.rb", to: "file/path2"
        end
      end
    end
  end

  context 'duplicate code comparison' do
    let(:dupe) { file_to_s duplicate_path }

    algorithms.each do |algorithm|
      context "using the #{algorithm} algorithm" do
        ngram_types.each do |ngram|
          context "with an ngram of #{ngram}" do
            it 'is 100%' do
              sim = subject.compare compare: dupe, to: dupe,
                                    ngram: ngram, algorithm: algorithm
              expect(sim).to eq 100
            end
          end
        end
      end
    end
  end

  context 'similar code comparison' do
    let(:sim_a) { file_to_s similar_a_path }
    let(:sim_b) { file_to_s similar_b_path }

    algorithms.each do |algorithm|
      context "using the #{algorithm} algorithm" do
        it 'is ~81%' do
          sim = subject.compare compare: sim_a, to: sim_b,
                                algorithm: algorithm
          expect(80..82).to cover(sim)
        end
      end
    end
  end

  context 'dissimilar code comparison' do
    let(:dissim_a) { file_to_s dissimilar_a_path }
    let(:dissim_b) { file_to_s dissimilar_b_path }

    algorithms.each do |algorithm|
      context "using the #{algorithm} algorithm" do
        it 'is ~22%' do
          sim = subject.compare compare: dissim_a, to: dissim_b,
                                algorithm: algorithm
          expect(21..23).to cover(sim)
        end
      end
    end
  end
end
