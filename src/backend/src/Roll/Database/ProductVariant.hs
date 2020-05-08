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
getByProduct productSlug = fmap go <$> getProductVariantsBySlug
  where
    slug
        :: String
    slug = Product.getSlug productSlug

    go
        :: ( E.Value String
           , E.Value Text
           , E.Value Text
           , E.Value Int
           , E.Value (Maybe Text)
           )
        -> ProductVariant
    go ( valueSlug, valueName, valueCode, valuePrice, valueDesc ) =
        ProductVariant
        { slug        = Slug (E.unValue valueSlug)
        , name        = E.unValue valueName
        , code        = E.unValue valueCode
        , price       = E.unValue valuePrice
        , description = E.unValue valueDesc
        }

    getProductVariantsBySlug
        :: I.SqlQuery [ ( E.Value String
                        , E.Value Text
                        , E.Value Text
                        , E.Value Int
                        , E.Value (Maybe Text)
                        )
                      ]
    getProductVariantsBySlug =
        E.select
        $ E.from
        $ \(productVariant `E.InnerJoin` product) -> do
            E.on
                (productVariant
                 ^. I.ProductVariantPid ==. product
                 ^. I.ProductId)
            E.where_ (product ^. I.ProductSlug ==. E.val slug)
            return
                ( productVariant ^. I.ProductVariantSlug
                , productVariant ^. I.ProductVariantName
                , productVariant ^. I.ProductVariantCode
                , productVariant ^. I.ProductVariantPrice
                , productVariant ^. I.ProductVariantDescription
                )
