module Roll.API.ProductOption
    ( Routes
    , handler
    ) where

import           Roll.Prelude
import           Roll.Prelude.API

import qualified Roll.Database               as Db
import qualified Roll.Database.Product       as Product
import qualified Roll.Database.ProductOption as ProductOption

data Routes route =
    Routes
    { getByProduct
          :: route
          :- Summary "Get options"
          :> Description "Get options by product."
          :> Capture "slug" Product.Slug
          :> Get '[JSON] [ ProductOption.Option ]
    }
    deriving stock Generic

handler
    :: Routes RollT
handler = Routes { getByProduct = get }

get
    :: Product.Slug -> RollM [ ProductOption.Option ]
get = Db.run . ProductOption.getByProductSlug

