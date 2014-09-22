module Synt.Parser (tokenize) where

import Data.List
import Language.Haskell.Exts.Lexer
import Language.Haskell.Exts.Parser

normalize :: [Loc Token] -> [String]
normalize = map $ showToken . unLoc

tokens :: String -> [Loc Token]
tokens x = fromParseResult $ lexTokenStream x

tokenize :: String -> [String]
tokenize x = normalize $ tokens x

