module Synt.SimilarSpec (similarSpec) where

import Test.Hspec
import Synt.Similar

similarSpec =
  describe "Similar" $ do
    describe "ngram" $ do
      it "generates a unigram" $ do
        let n = ngram 1 ["1", "2", "3"]
        n `shouldBe` [["1"], ["2"], ["3"]]

      it "generates a bigram" $ do
        let n = ngram 2 ["1", "2", "3"]
        n `shouldBe` [["1", "2"], ["2", "3"]]

      it "generates a trigram" $ do
        let n = ngram 3 ["1", "2", "3", "4"]
        n `shouldBe` [["1", "2", "3"], ["2", "3", "4"]]

    describe "ngrams" $ do
      it "generates a list of unigrams and bigrams" $ do
        let n = ngrams (1, 2) ["1", "2", "3"]
        n `shouldBe` ["1", "2", "3", "12", "23"]

      it "generates a list of bigrams and trigrams" $ do
        let n = ngrams (2, 3) ["1", "2", "3"]
        n `shouldBe` ["12", "23", "123"]

    describe "ngramRange" $ do
      it "accepts a single integer" $
        ngramRange "1" [] `shouldBe` (1, 1)

      it "accetpes all" $
        ngramRange "all" [1, 2, 3, 4] `shouldBe` (1, 4)

      it "accepts a range" $
        ngramRange "1..3" [] `shouldBe` (1, 3)

      it "accepts empty string" $
        ngramRange "" [] `shouldBe` (1, 1)

    describe "sim" $ do
      let ng = "1"

      describe "duplicate code" $ do
        let dupe = "x = x ^ 2"
        let algorithm = "tanimoto"

        it "is 100" $
          sim dupe dupe algorithm ng `shouldBe` 100

      describe "similar code" $ do
        let simA = "x l = (2 * x) ^ l"
        let simB = "z l = (2 * z) ^ l"
        let algorithm = "jaccard"

        it "is ~0.72" $ do
          let x = sim simA simB algorithm ng
          x `shouldSatisfy` (< 73)
          x `shouldSatisfy` (> 71)

      describe "dissimilar code" $ do
        let algorithm = "jaccard"
        let dissimA = "w x y z = w ^ 3 ++ z"
        let dissimB = "a b c d = a ++ b ++ c"

        it "is ~0.14" $ do
          let x = sim dissimA dissimB algorithm ng
          x `shouldSatisfy` (< 15)
          x `shouldSatisfy` (> 13)
