module Roll.API.Static
    ( API
    , handler
    ) where

import Roll.Prelude
import Roll.Prelude.API

import qualified Servant.RawM        as Raw
import           Servant.RawM.Server (serveDirectoryFileServer)
type API = Raw.RawM

handler :: ServerT API RollM
handler =
    view (field @"staticContentPath") >>= serveDirectoryFileServer
