module Lib
  ( spaces',
    digits',
    freqs,
    pad,
    if',
    v2m,
  )
where

import Control.Monad
import qualified Data.List as L
import Data.Map.Lazy (Map)
import qualified Data.Map.Lazy as M
import Linear.V2
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

v2m :: [[a]] -> Map (V2 Int) a
v2m = M.fromList . concat . zipWith (\y -> map (\(x, c) -> (V2 x y, c))) [0 ..] . map (zip [0 ..])
