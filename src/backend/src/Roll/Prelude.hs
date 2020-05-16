module Roll.Prelude
    ( module Prelude
    , ByteString
    , Text
    , head
    , tail
    , listToMaybe
    , catMaybes
    , module Control.Applicative
    , module Control.Lens
    , module Control.Monad
    , module Data.Generics.Product.Fields
    , module Data.Foldable
    , module Data.Functor
    , module Data.Void
    , module Data.Proxy
    , module GHC.Generics
    , module System.FilePath.Posix
    ) where

import           Control.Applicative
    ( (<|>)
    )
import           Control.Lens
    ( (^.)
    , view
    )
import           Control.Monad
    ( (<=<)
    , (>=>)
    )
import           Data.ByteString.Lazy
    ( ByteString
    )
import           Data.Foldable
    ( asum
    )
import           Data.Functor
    ( ($>)
    )
import           Data.Generics.Product.Fields
    ( field
    )
import           Data.Maybe
    ( catMaybes
    , listToMaybe
    )
import           Data.Proxy
    ( Proxy(..)
    )
import           Data.Text
    ( Text
    )
import           Data.Void
    ( Void
    , absurd
    )
import           GHC.Generics
    ( Generic
    , Generic1
    )
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
import           System.FilePath.Posix
    ( (</>)
    )

head
    :: [ a ] -> Maybe a
head =
    \case
        []      -> Nothing
        (x : _) -> Just x

tail
    :: [ a ] -> Maybe [ a ]
tail =
    \case
        []       -> Nothing
        (_ : xs) -> Just xs
