module Roll.API.Category
    ( getBySlug
    , getProducts
    , Product
    , module Exp
    ) where

import Prelude

import Control.Monad.Except (ExceptT)
import Data.Maybe (Maybe)
import Effect.Aff (Aff)
import Roll.API.Internal (Error) as Exp
import Roll.API.Internal as I

getBySlug :: String -> ExceptT I.Error Aff String
getBySlug slug = I.get $ "/category/" <> slug

type Product =
    { slug :: String
    , name :: String
    , description :: Maybe String
    }

getProducts :: String -> ExceptT I.Error Aff (Array Product)
getProducts slug = I.get $ "/category/" <> slug <> "/products"
