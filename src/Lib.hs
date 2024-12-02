module Lib
  ( spaces',
    digits',
    freqs,
  )
where

import Data.Map.Lazy (Map)
import qualified Data.Map.Lazy as M
import Text.Parsec

spaces' :: (Stream s m Char) => ParsecT s u m ()
spaces' = skipMany (char ' ')

digits' :: (Stream s m Char) => ParsecT s u m Int
digits' = read <$> many1 digit

freqs :: (Ord a) => [a] -> Map a Int
freqs = M.fromListWith (+) . map (,1)
