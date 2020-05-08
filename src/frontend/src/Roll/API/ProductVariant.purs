module Roll.API.ProductVariant
    ( getProducts
    , ProductVariant
    , module Exp
    ) where

import Prelude

import Control.Monad.Except (ExceptT)
import Data.Maybe (Maybe)
import Effect.Aff (Aff)
import Roll.API.Internal (Error) as Exp
import Roll.API.Internal as I

type ProductVariant =
    { slug        :: String
    , name        :: String
    , code        :: String
    , price       :: Int
    , description :: Maybe String
    }

getProducts :: String -> ExceptT I.Error Aff (Array ProductVariant)
getProducts slug = I.get $ "/product/" <> slug
