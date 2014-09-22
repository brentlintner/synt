module Main where

import Test.Hspec
import Synt.SimilarSpec

spec :: Spec
spec = similarSpec

main :: IO ()
main = hspec spec
