module Synt.Similar.Jaccard (jaccard) where

import Data.List

float :: Int -> Float
float = fromIntegral

jaccard :: [String] -> [String] -> Float
jaccard a b = do
  let i = a `intersect` b
  let u = a `union` b
  float (length i) / float (length u) * 100
