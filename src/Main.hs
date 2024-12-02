module Main where

import Data.List as L
import Lib
import Text.Parsec

parser :: Parsec String Int [(Int, Int)]
parser = sepEndBy1 (liftA2 (,) (digits' <* spaces') digits') newline

main :: IO ()
main = do
  input <- readFile "input"
  case runParser parser 0 "input" input of
    Left err -> print err
    Right r -> do
      print $ run r
      where
        run = sum . map abs . (zipWith (-) <$> (L.sort . map snd) <*> (L.sort . map fst))
