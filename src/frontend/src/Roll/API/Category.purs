module Roll.API.Category
    ( getBySlug
    , getProducts
    , getRestrictedProducts
    , getByProductVariantSlug
    , Product
    , module Exp
    ) where

import Prelude

import Control.Monad.Except (ExceptT)
import Data.Array as A
import Data.Foldable (fold)
import Data.Maybe (Maybe)
import Effect.Aff (Aff)
import Roll.API.Internal (Error) as Exp
import Roll.API.Internal as I

getBySlug :: String -> ExceptT I.Error Aff String
getBySlug slug = I.get $ "/category/" <> slug

type Product =
    { slug        :: String
    , name        :: String
    , price       :: Int
    , description :: Maybe String
    }

getProducts :: String -> ExceptT I.Error Aff (Array Product)
getProducts slug = getRestrictedProducts slug mempty

getRestrictedProducts
    :: String
    -> Array String
    -> ExceptT I.Error Aff (Array Product)
getRestrictedProducts slug restrictions =
    I.get <<< fold $
        [ "/category/" , slug , "/products" ] <> A.mapWithIndex go restrictions
  where
    go 0 s = "?products=" <> s
    go _ s = "&products=" <> s

type Category =
    { slug :: String
    , name :: String
    }

getByProductVariantSlug :: String -> ExceptT I.Error Aff (Maybe Category)
getByProductVariantSlug slug = I.get $ "/category/byProductVariant/" <> slug
