module Roll.Prelude
    ( module Prelude
    , head
    , tail
    ) where

import           Prelude
    hiding ( (!!)
           , (^)
           , cycle
           , div
           , divMod
           , dropWhile
           , fail
           , foldl
           , foldr1
           , head
           , init
           , last
           , length
           , log
           , maximum
           , minimum
           , mod
           , pred
           , product
           , quot
           , quotRem
           , read
           , rem
           , reverse
           , succ
           , sum
           , tail
           , toEnum
           )

head :: [ a ] -> Maybe a
head = \case
    []      -> Nothing
    (x : _) -> Just x

tail :: [ a ] -> Maybe [ a ]
tail = \case
    []       -> Nothing
    (_ : xs) -> Just xs
