module Roll.API.Dev
    ( Routes
    , handler
    ) where

import           Roll.Prelude
import           Roll.Prelude.API

data Routes route =
    Routes
    { ping
          :: route
          :- Summary "Ping/pong"
          :> Description "Basic ping API to check whether the server is alive."
          :> "ping"
          :> Get '[JSON] NoContent
    }
    deriving stock Generic

handler
    :: Routes RollT
handler = Routes { ping = pure NoContent }
