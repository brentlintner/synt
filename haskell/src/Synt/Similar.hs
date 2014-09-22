module Synt.Similar (sim, ngramRange, ngram, ngrams) where

import Synt.Parser
import Data.List
import Data.List.Split
import Data.Ix
import Data.Maybe
import Text.RegexPR
import Synt.Similar.Jaccard
import Synt.Similar.Tanimoto

int :: String -> Int
int x = read x :: Int

tupint :: [String] -> (Int, Int)
tupint [x, y] = (int x, int y)

join :: [[String]] -> [String]
join = map (foldr (++) "")

ngramRange :: String -> [a] -> (Int, Int)
ngramRange n l
  | null n || n == "" = (1, 1)
  | n == "all" = (1, length l)
  | isJust (matchRegexPR "\\.\\." n) = tupint $ splitOn ".." n
  | not (null n) = (int n, int n)

ngram :: Int -> [String] -> [[String]]
ngram _ [_] = []
ngram 1 list = map (: []) list
ngram n list = take n list : if length list - 1 >= n
                             then ngram n (tail list)
                             else []

ngrams :: (Int, Int) -> [String] -> [String]
ngrams r list = concatMap (\x -> join $ ngram x list) (range r)

sim' :: [String] -> [String] -> String -> String -> Float
sim' cmp to algo n = do
  let r = ngramRange n cmp
  let a = ngrams r cmp
  let b = ngrams r to

  if algo == "tanimoto"
  then tanimoto a b
  else jaccard a b

sim :: String -> String -> String -> String -> Float
sim from to = sim' (tokenize from) (tokenize to)
