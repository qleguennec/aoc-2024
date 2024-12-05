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

parser :: Parsec String Bool ([(Int, Int)], [[Int]])
parser = do
  rules <- many1 ((,) <$> (digits' <* char '|') <*> (digits' <* newline))
  newline
  pages <- sepEndBy1 (sepBy1 digits' (char ',')) newline
  pure (rules, pages)

respect :: (Int, Int) -> [Int] -> Bool
respect rule = (`L.isSubsequenceOf` p2l rule) . filter (`S.member` p2s rule)

main :: IO ()
main = do
  input <- readFile "input"
  case runParser parser True "input" input of
    Left err -> print err

    Right (rules, pages) -> print run
      where
        run = sum . map middle . filter respectAll $ pages
        respectAll = flip all rules . flip respect
