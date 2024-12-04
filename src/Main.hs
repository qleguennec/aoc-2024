module Main where

import Control.Monad
import Control.Monad.Zip
import Data.Functor
import Data.List as L
import Data.Map.Lazy (Map)
import qualified Data.Map.Lazy as M
import Data.Maybe
import Lib
import Linear.V2
import Text.Parsec

parser :: Parsec String Bool [[Char]]
parser = sepEndBy1 (many1 (noneOf ['\n'])) newline

main :: IO ()
main = do
  input <- readFile "input"
  case runParser parser True "input" input of
    Left err -> print err
    Right r -> print $ run r
      where
        run = length . filter (== "XMAS") . join . map square . M.keys . M.filter (== 'X') . v2m
        m = v2m r
        square x = map (mapMaybe get . take 4 . flip iterate x . (+)) $ filter (/= V2 0 0) $ join (liftA2 V2) [-1 .. 1]
        get = flip M.lookup m
