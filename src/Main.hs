module Main where

import Control.Monad
import Data.List as L
import Data.Map.Lazy (Map)
import qualified Data.Map.Lazy as M
import Data.Maybe
import Lib
import Text.Parsec

parser :: Parsec String Int [[Int]]
parser = sepEndBy1 (sepBy1 digits' spaces') newline

main :: IO ()
main = do
  input <- readFile "input"
  case runParser parser 0 "input" input of
    Left err -> print err
    Right r -> print $ run r
      where
        run = length . filter (((||) <$> all increasing <*> all decreasing) . ap (zipWith (-)) tail)
        increasing x = x >= 1 && x <= 3
        decreasing = increasing . negate
