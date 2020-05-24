module Roll.Prelude
    ( ByteString
    , Text
    , module Control.Applicative
    , module Control.Lens
    , module Control.Monad
    , module Data.Bifunctor
    , module Data.Foldable
    , module Data.Functor
    , module Data.Generics.Product.Fields
    , module Data.Maybe
    , module Data.Proxy
    , module Data.Void
    , module GHC.Generics
    , module Prelude
    , module System.FilePath.Posix
    , head
    , tail
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
import           Data.Bifunctor
    ( Bifunctor(..)
    )
import           Data.ByteString.Lazy
    ( ByteString
    )
import           Data.Foldable
    ( asum
    , fold
    )
import           Data.Functor
    ( ($>)
    )
import           Data.Generics.Product.Fields
    ( field
    )
import           Data.Maybe
    ( catMaybes
    , fromMaybe
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
