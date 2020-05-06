module Roll.API.ProductVariant
    ( Routes
    , handler
    ) where

import           Roll.Prelude
import           Roll.Prelude.API

import qualified Roll.Database                as Db
import qualified Roll.Database.Product        as Product
import qualified Roll.Database.ProductVariant as ProductVariant

newtype Routes route =
    Routes
    { get
          :: route
          :- Summary "Get product variant"
          :> Description "Get product variants by product."
          :> Capture "slug" Product.Slug
          :> Get '[JSON] [ ProductVariant.ProductVariant ]
    }
    deriving stock Generic

handler
    :: Routes RollT
handler = Routes { get = getBySlug }

getBySlug
    :: Product.Slug -> RollM [ ProductVariant.ProductVariant ]
getBySlug = throwIfEmpty <=< Db.run . ProductVariant.getByProduct
