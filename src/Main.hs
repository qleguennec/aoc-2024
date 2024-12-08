{-# HLINT ignore "Use lambda-case" #-}
{-# OPTIONS_GHC -Wno-overlapping-patterns #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

module Main where

import Control.Monad
import Control.Monad.Zip
import Data.Bifunctor
import Data.Bool
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

type Rule = (Int, Int)

type Rules = S.Set Rule

type Update = [Int]

parser :: Parsec String Bool (Rules, [Update])
parser = do
  rules <- S.fromList <$> many1 ((,) <$> (digits' <* char '|') <*> (digits' <* newline))
  newline
  pages <- sepEndBy1 (sepBy1 digits' (char ',')) newline
  pure (rules, pages)

incorrect :: Rule -> [Int] -> Bool
incorrect rule = ((&&) <$> (== 2) . length <*> (/= p2l rule)) . filter (`S.member` p2s rule)

main :: IO ()
main = do
  input <- readFile "input"
  case runParser parser True "input" input of
    Left err -> print err
    Right (rules, pages) -> print run
      where
        run =
          sum
            . map (middle . sortBy (((bool GT LT . flip S.member rules) .) . (,)))
            . filter (not . S.null . flip S.filter rules . flip incorrect)
            $ pages
