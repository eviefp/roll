module Roll.API
    ( Routes
    , handler
    ) where

import           Roll.Prelude
import           Roll.Prelude.API

import qualified Roll.API.Dev     as Dev

data Routes route =
    Routes
    { api
          :: route
          :- "dev"
          :> ToServantApi Dev.Routes
    }
    deriving stock Generic

handler
    :: Routes AsServer
handler =
    Routes
    { api = genericServer Dev.handler
    }
