module Lib
  ( spaces',
    digits',
    freqs,
    pad,
    if',
  )
where

import Control.Monad
import qualified Data.List as L
import Data.Map.Lazy (Map)
import qualified Data.Map.Lazy as M
import Text.Parsec

spaces' :: (Stream s m Char) => ParsecT s u m ()
spaces' = skipMany (char ' ')

digits' :: (Stream s m Char) => ParsecT s u m Int
digits' = read <$> many1 digit

freqs :: (Ord a) => [a] -> Map a Int
freqs = M.fromListWith (+) . map (,1)

pad :: (a -> a -> a) -> [a] -> [a]
pad f = ap (zipWith f) tail

if' :: Bool -> a -> a -> a
if' p a b = if p then a else b
