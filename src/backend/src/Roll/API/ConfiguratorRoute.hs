module Roll.API.ConfiguratorRoute
    ( Routes
    , handler
    ) where

import           Roll.Prelude
import           Roll.Prelude.API

import qualified Roll.Database.ProductVariant as ProductVariant

import qualified Control.Monad.IO.Class       as MonadIO
import qualified Data.ByteString.Lazy         as BS

data Routes route =
    Routes
    { get
          :: route
          :- Summary "Configurator html"
          :> Description "Redirect to the html page."
          :> Get '[HTML] ByteString
    , getWithproduct
          :: route
          :- Summary "Configurator html"
          :> Description "Redirect to the html page."
          :> Capture "slug" ProductVariant.Slug
          :> Get '[HTML] ByteString
    }
    deriving stock Generic

handler
    :: Routes RollT
handler = Routes { get = getHtml, getWithproduct = const getHtml }

getHtml
    :: RollM ByteString
getHtml =
    view (field @"staticContentPath")
    >>= MonadIO.liftIO . BS.readFile . (</> "configurator.html")


