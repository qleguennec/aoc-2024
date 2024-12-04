module Main where

import Control.Monad
import Control.Monad.Zip
import Data.Bifunctor
import Data.Functor
import Data.List as L
import Data.Map.Lazy (Map)
import qualified Data.Map.Lazy as M
import Data.Maybe
import Data.Set (Set)
import qualified Data.Set as S
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
        run = length . filter (== S.fromList (replicate 2 (S.fromList ['S', 'M']))) . map gets . M.keys . M.filter (== 'A') . v2m
        m = v2m r
        gets x = S.fromList $ S.fromList . catMaybes . p2l . ap (curry $ join bimap (get . (+ x))) negate <$> [V2 1 1, V2 1 (-1)]
        get = flip M.lookup m
