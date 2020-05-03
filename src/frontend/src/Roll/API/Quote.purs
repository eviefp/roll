module Roll.API.Quote
    ( get
    , module Exp
    ) where

import Prelude

import Control.Monad.Except (ExceptT)
import Effect.Aff (Aff)
import Roll.API.Internal as I
import Roll.API.Internal (Error) as Exp

get :: Int -> ExceptT I.Error Aff String
get idx = I.get $ "/quote/" <> show idx
