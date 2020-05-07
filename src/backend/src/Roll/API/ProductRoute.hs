module Roll.API.ProductRoute
    ( Routes
    , handler
    ) where

import           Roll.Prelude
import           Roll.Prelude.API

import qualified Roll.Database          as Db
import qualified Roll.Database.Product  as Product

import qualified Control.Monad.IO.Class as MonadIO
import qualified Data.ByteString.Lazy   as BS

newtype Routes route =
    Routes
    { get
          :: route
          :- Summary "Product html"
          :> Description "Redirect to the html page if the product matches."
          :> Capture "slug" Product.Slug
          :> Get '[HTML] ByteString
    }
    deriving stock Generic

handler
    :: Routes RollT
handler = Routes { get = getProductHtml }

getProductHtml
    :: Product.Slug -> RollM ByteString
getProductHtml =
    maybe (throwError err404) (const html) <=< Db.run . Product.getBySlug

html
    :: RollM ByteString
html =
    view (field @"staticContentPath")
    >>= MonadIO.liftIO . BS.readFile . (</> "product.html")

