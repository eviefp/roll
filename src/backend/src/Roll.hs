module Roll
    ( startApp
    ) where

import           Roll.Prelude
import           Roll.Prelude.API

import           Network.Wai.Handler.Warp
    ( run
    )

import           Servant.Server
    ( serve
    )

import qualified Roll.API                 as RollAPI

type API =
    ToServantApi RollAPI.Routes

handler
    :: Server API
handler =
    genericServer RollAPI.handler

startApp
    :: IO ()
startApp =
    run 8080 $ serve (Proxy @API) handler
