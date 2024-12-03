module Main where

import Control.Monad
import Data.Functor
import Data.List as L
import Data.Map.Lazy (Map)
import qualified Data.Map.Lazy as M
import Data.Maybe
import Lib
import Text.Parsec

parser :: Parsec String Int [(Int, Int)]
parser =
  catMaybes
    <$> many1
      ( try ((string "mul" >> char '(' >> liftA2 (,) (digits' <* char ',') digits' <* char ')') <&> Just)
          <|> (anyChar $> Nothing)
      )

main :: IO ()
main = do
  input <- readFile "input"
  case runParser parser 0 "input" input of
    Left err -> print err
    Right r -> print $ run r
      where
        run = sum . map (uncurry (*))
