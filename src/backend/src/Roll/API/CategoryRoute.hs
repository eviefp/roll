module Roll.API.CategoryRoute
    ( Routes
    , handler
    ) where

import           Roll.Prelude
import           Roll.Prelude.API

import qualified Roll.Database          as Db
import qualified Roll.Database.Category as Category

import qualified Control.Monad.IO.Class as MonadIO
import qualified Data.ByteString.Lazy   as BS

newtype Routes route =
    Routes
    { get
          :: route
          :- Summary "Category html"
          :> Description "Redirect to the html page if the category matches."
          :> Capture "slug" Category.Slug
          :> Get '[HTML] ByteString
    }
    deriving stock Generic

handler
    :: Routes RollT
handler = Routes { get = getCategoryHtml }

getCategoryHtml
    :: Category.Slug -> RollM ByteString
getCategoryHtml =
    maybe (throwError err404) (const html) <=< Db.run . Category.getBySlug

html
    :: RollM ByteString
html =
    view (field @"staticContentPath")
    >>= MonadIO.liftIO . BS.readFile . (</> "category.html")

