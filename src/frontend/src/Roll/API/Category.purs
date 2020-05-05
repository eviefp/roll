module Roll.API.Category
    ( getBySlug
    , module Exp
    ) where

import Prelude

import Control.Monad.Except (ExceptT)
import Effect.Aff (Aff)
import Roll.API.Internal as I
import Roll.API.Internal (Error) as Exp

getBySlug :: String -> ExceptT I.Error Aff String
getBySlug slug = I.get $ "/category/" <> slug
