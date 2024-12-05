module Lib
  ( spaces',
    digits',
    freqs,
    pad,
    if',
    v2m,
    p2l,
    l2s,
    p2s,
    middle,
  )
where

import Control.Monad
import qualified Data.List as L
import Data.Map.Lazy (Map)
import qualified Data.Map.Lazy as M
import Data.Set (Set)
import qualified Data.Set as S
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

p2l :: (a, a) -> [a]
p2l (x, y) = [x, y]

l2s :: (Ord a) => [a] -> Set a
l2s = S.fromList

p2s :: (Ord a) => (a, a) -> Set a
p2s = l2s . p2l

middle :: [a] -> a
middle = ap (!!) $ pred . (`div` 2) . succ . length
