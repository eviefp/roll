module Roll.API.Configurator
    ( calculatePrice
    , Input
    , Output
    , InputData
    ) where

import Prelude

import Control.Monad.Except (ExceptT)
import Data.Maybe (Maybe(..))
import Effect.Aff (Aff)
import Roll.API.Internal as I

type Output a =
    { system :: Maybe a
    , material :: Maybe a
    , work :: Maybe a
    }

type InputData =
    { inaltime :: Int
    , latime :: Int
    }

type Input =
    { groups :: Output String
    , inputs :: InputData
    }

calculatePrice :: Input -> ExceptT I.Error Aff (Output Int)
calculatePrice = I.put "/config" <<< Just
