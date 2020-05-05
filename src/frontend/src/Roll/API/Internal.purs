module Roll.API.Internal
    ( URL
    , Error (..)
    , get
    ) where

import Prelude

import Affjax as Affjax
import Affjax.ResponseFormat as RF
import Control.Monad.Except (ExceptT(..), except)
import Data.Bifunctor (lmap)
import Effect.Aff (Aff)
import Foreign (MultipleErrors)
import Simple.JSON as Json

type URL = String

data Error
    = AffjaxError Affjax.Error
    | ParsingError MultipleErrors
    | UnknownError

get :: forall a. Json.ReadForeign a => URL -> ExceptT Error Aff a
get url =
    ExceptT (lmap AffjaxError <$> Affjax.get RF.string url)
        >>= except <<< lmap ParsingError <<< Json.readJSON <<< _.body
