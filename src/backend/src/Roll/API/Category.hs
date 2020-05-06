module Roll.API.Category
    ( Routes
    , handler
    ) where

import           Roll.Prelude
import           Roll.Prelude.API

import qualified Roll.Database          as Db
import qualified Roll.Database.Category as Category
import qualified Roll.Database.Product  as Product

data Routes route =
    Routes
    { get
          :: route
          :- Summary "Get category"
          :> Description "Get category name."
          :> Capture "slug" Category.Slug
          :> Get '[JSON] Category.Name
    , products
          :: route
          :- Summary "Get products"
          :> Description "Get products for the category."
          :> Capture "slug" Category.Slug
          :> "products"
          :> Get '[JSON] [ Product.Product ]
    }
    deriving stock Generic

handler
    :: Routes RollT
handler = Routes { get = getBySlug, products = getProducts }

getBySlug
    :: Category.Slug -> RollM Category.Name
getBySlug = maybe (throwError err404) pure <=< Db.run . Category.getBySlug

getProducts
    :: Category.Slug -> RollM [ Product.Product ]
getProducts = throwIfEmpty <=< Db.run . Product.getByCategory
  where
    throwIfEmpty
        :: [ Product.Product ] -> RollM [ Product.Product ]
    throwIfEmpty =
        \case
            [] -> throwError err404
            xs -> pure xs
