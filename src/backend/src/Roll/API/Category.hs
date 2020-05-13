module Roll.API.Category
    ( Routes
    , handler
    ) where

import           Roll.Prelude
import           Roll.Prelude.API

import qualified Roll.Database                as Db
import qualified Roll.Database.Category       as Category
import qualified Roll.Database.Product        as Product
import qualified Roll.Database.ProductVariant as ProductVariant

import qualified Control.Monad.IO.Class       as MonadIO

data Routes route =
    Routes
    { get
          :: route
          :- Summary "Get category"
          :> Description "Get category name."
          :> Capture "slug" Category.Slug
          :> Get '[JSON] Text
    , products
          :: route
          :- Summary "Get products"
          :> Description "Get products for the category."
          :> Capture "slug" Category.Slug
          :> "products"
          :> Get '[JSON] [ Product.Product ]
    , getProductsFiltered
          :: route
          :- Summary "Get filtered products"
          :> Description "Get products for the category, that are compatible."
          :> Capture "slug" Category.Slug
          :> "products"
          :> ReqBody '[JSON] [ Product.Slug ]
          :> Put '[JSON] [ Product.Product ]
    , getByProductVariant
          :: route
          :- Summary "Get by product variant"
          :> Description "Get category by product variant slug."
          :> "byProductVariant"
          :> Capture "slug" ProductVariant.Slug
          :> Get '[JSON] Category.Category
    }
    deriving stock Generic

handler
    :: Routes RollT
handler =
    Routes
    { get                 = getBySlug
    , products            = (`getProducts` [])
    , getProductsFiltered = getProducts
    , getByProductVariant = byProductVariant
    }

getBySlug
    :: Category.Slug -> RollM Text
getBySlug = maybe (throwError err404) pure <=< Db.run . Category.getBySlug

getProducts
    :: Category.Slug -> [ Product.Slug ] -> RollM [ Product.Product ]
getProducts slug slugs =
    do
        MonadIO.liftIO
            $ print
            $ Product.getSlug <$> slugs
        throwIfEmpty <=< Db.run . Product.getByCategory slug
            $ slugs

byProductVariant
    :: ProductVariant.Slug -> RollM Category.Category
byProductVariant =
    maybe (throwError err404) pure
    <=< Db.run . Category.getByProductVariantSlug

