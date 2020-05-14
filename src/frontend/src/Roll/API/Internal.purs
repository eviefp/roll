module Roll.API.Internal
    ( URL
    , Error (..)
    , get
    , put
    ) where

import Prelude

import Affjax as Affjax
import Affjax.RequestBody as RB
import Affjax.ResponseFormat as RF
import Control.Monad.Except (ExceptT(..), except)
import Data.Bifunctor (lmap)
import Data.Maybe (Maybe)
import Effect.Aff (Aff)
import Foreign (MultipleErrors)
import Simple.JSON as Json
import Unsafe.Coerce (unsafeCoerce)

type URL = String

data Error
    = AffjaxError Affjax.Error
    | ParsingError MultipleErrors
    | UnknownError

get :: forall a. Json.ReadForeign a => URL -> ExceptT Error Aff a
get url =
    ExceptT (lmap AffjaxError <$> Affjax.get RF.string url)
        >>= except <<< lmap ParsingError <<< Json.readJSON <<< _.body

-- TODO: this fails on empty arrays for example due to encoding problems.
put
    :: forall a b
     . Json.ReadForeign a
    => Json.WriteForeign b
    => URL
    -> Maybe b
    -> ExceptT Error Aff a
put url body =
    ExceptT (lmap AffjaxError <$> Affjax.put RF.string url body')
        >>= except <<< lmap ParsingError <<< Json.readJSON <<< _.body
  where
    body' :: Maybe RB.RequestBody
    body' = RB.json <$> unsafeCoerce (Json.write body)
