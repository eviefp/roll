module Roll.API.Static
    ( API
    , handler
    ) where

import           Roll.Prelude
import           Roll.Prelude.API

import qualified Servant.RawM     as Raw

type API = Raw.RawM

handler
    :: ServerT API RollM
handler =
    view (field @"staticContentPath")
    >>= Raw.serveDirectoryFileServer
