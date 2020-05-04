module Roll.API.Category
    ( Routes
    , handler
    ) where

import           Roll.Prelude
import           Roll.Prelude.API

import qualified Roll.Database          as Db
import qualified Roll.Database.Category as Category

data Routes route =
    Routes
    { get
          :: route
          :- Summary "Get category"
          :> Description "Get category name."
          :> Capture "slug" Category.Slug
          :> Get '[JSON] Category.Name
    }
    deriving stock Generic

handler
    :: Routes RollT
handler = Routes { get = getBySlug }

getBySlug
    :: Category.Slug -> RollM Category.Name
getBySlug = maybe (throwError err404) pure <=< Db.run . Category.getBySlug
