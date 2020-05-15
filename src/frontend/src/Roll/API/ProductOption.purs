module Roll.API.ProductOption
    ( getByProduct
    , Option
    , module Exp
    ) where

import Prelude

import Control.Monad.Except (ExceptT)
import Effect.Aff (Aff)
import Roll.API.Internal (Error) as Exp
import Roll.API.Internal as I

type Option =
    { name        :: String
    , description :: String
    , options     :: Array String
    }

getByProduct :: String -> ExceptT I.Error Aff (Array Option)
getByProduct slug = I.get $ "/option/" <> slug

