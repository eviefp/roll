module Roll.Database.ProductVariant
    ( Slug(getSlug)
    , ProductVariant(slug, name, code, description)
    , getByProduct
    ) where

import           Roll.Prelude
    hiding ( (^.)
           )

import qualified Roll.Database.Internal as I
import qualified Roll.Database.Product  as Product

import qualified Data.Aeson             as Aeson
import qualified Database.Esqueleto     as E
import           Database.Esqueleto
    ( (==.)
    , (^.)
    )
import qualified Servant                as Servant

newtype Slug =
    Slug
    { getSlug
          :: String
    }
    deriving newtype ( Aeson.ToJSON, Servant.FromHttpApiData )

data ProductVariant =
    ProductVariant
    { slug
          :: Slug
    , name
          :: Text
    , code
          :: Text
    , price
          :: Int
    , description
          :: Maybe Text
    }
    deriving stock Generic
    deriving anyclass ( Aeson.ToJSON )

getByProduct
    :: Product.Slug -> I.SqlQuery [ ProductVariant ]
getByProduct productSlug = fmap (go . E.entityVal) <$> getProductVariantsBySlug
  where
    slug
        :: String
    slug = Product.getSlug productSlug

    go
        :: I.ProductVariant -> ProductVariant
    go pv =
        ProductVariant
        { slug        = Slug (I.productVariantSlug pv)
        , name        = I.productVariantName pv
        , code        = I.productVariantCode pv
        , price       = I.productVariantPrice pv
        , description = I.productVariantDescription pv
        }

    getProductVariantsBySlug
        :: I.SqlQuery [ E.Entity I.ProductVariant ]
    getProductVariantsBySlug =
        E.select
        $ E.from
        $ \(productVariant `E.InnerJoin` product) -> do
            E.on
                (productVariant
                 ^. I.ProductVariantPid ==. product
                 ^. I.ProductId)
            E.where_ (product ^. I.ProductSlug ==. E.val slug)
            return productVariant
