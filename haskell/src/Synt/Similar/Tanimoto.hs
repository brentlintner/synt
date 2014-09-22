module Synt.Similar.Tanimoto (tanimoto) where

import Data.List

float :: Int -> Float
float = fromIntegral

tanimoto :: [String] -> [String] -> Float
tanimoto a b = do
  let i = length $ a `intersect` b
  float i / float (length a + length b - i) * 100
