module Synt.CLI (run) where

import System.Exit
import System.IO
import System.Console.ArgParser
import Synt.Similar

data API = API {
  compareOpt :: String,
  toOpt :: String,
  stringCompareOpt :: Bool,
  algorithmOpt :: String,
  ngramOpt :: String,
  thresholdOpt :: Int
} deriving (Show)

parser :: ParserSpec API
parser = API
  `parsedBy` reqFlag "compare"
    `Descr` "File path to compare against."

  `andBy` reqFlag "to"
    `Descr` "File path to compare to."

  `andBy` boolFlag "string-compare"
    `Descr` "Consider -c and -t options to be string values, " ++
            "instead of file paths to read in."

  `andBy` optFlag "jaccard" "algorithm"
    `Descr` "Similarity algorithm " ++
            "[default=jaccard,tanimoto]."

  `andBy` optFlag "1" "ngram"
    `Descr` "Specify what ngrams are generated " ++
            "and used for comparing token sequences." ++
            " [default=1,2,4..5,10,...,all]"

  `andBy` optFlag 0 "min-threshold"
    `Descr` "Similarity threshold (ex: -m 70). " ++
            "Exit with error when similarity % is below value."

pastThreshold :: Int -> Float -> Bool
pastThreshold t d = d < fromIntegral t

exitWithLimit :: Int -> Float -> IO ()
exitWithLimit limit num =
  if pastThreshold limit num
  then do
    putStrLn ("Fail! Threshold of " ++ show limit ++ "% reached.")
    exitFailure
  else do
    putStrLn ("Inputs are " ++ show (round num) ++ "% similar.")
    exitSuccess

interpret :: API -> IO ()
interpret api = do
    let cmp = compareOpt api
    let to = toOpt api
    let algo = algorithmOpt api
    let ngram = ngramOpt api
    let limit = thresholdOpt api
    let readingFromString = stringCompareOpt api
    let compareItems c t = exitWithLimit limit (sim c t algo ngram)

    if readingFromString
    then compareItems cmp to
    else do
      fcmp <- readFile cmp
      fto <- readFile to
      compareItems fcmp fto

run :: IO ()
run = withParseResult parser interpret
