module Roll.API
    ( Routes
    , handler
    , RollM(..)
    , RollT
    ) where

import           Roll.Prelude
import           Roll.Prelude.API

import qualified Roll.API.Dev     as Dev
import qualified Roll.API.Quote   as Quote
import qualified Roll.API.Static  as Static

data Routes route =
    Routes
    { dev
          :: route
          :- "dev"
          :> ToServantApi Dev.Routes
    , quote
          :: route
          :- "quote"
          :> ToServantApi Quote.Routes
    , static
          :: route
          :- Static.API
    }
    deriving stock Generic

handler
    :: Routes RollT
handler =
    Routes
    { dev    = genericServerT Dev.handler
    , quote  = genericServerT Quote.handler
    , static = Static.handler
    }
