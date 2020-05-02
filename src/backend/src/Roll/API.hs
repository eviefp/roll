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
    }
    deriving stock Generic

handler
    :: Routes RollT
handler =
    Routes
    { dev   = genericServerT Dev.handler
    , quote = genericServerT Quote.handler
    }
