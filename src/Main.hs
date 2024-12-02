module Main where

import Control.Monad
import Data.List as L
import Data.Map.Lazy (Map)
import qualified Data.Map.Lazy as M
import Data.Maybe
import Lib
import Text.Parsec

parser :: Parsec String Int [(Int, Int)]
parser = sepEndBy1 (liftA2 (,) (digits' <* spaces') digits') newline

main :: IO ()
main = do
  input <- readFile "input"
  case runParser parser 0 "input" input of
    Left err -> print err
    Right r -> print $ run r
      where
        run = (sum .) . map . ap (*) <$> ((fromMaybe 0 <$>) . flip M.lookup . freqs . map snd) <*> map fst
