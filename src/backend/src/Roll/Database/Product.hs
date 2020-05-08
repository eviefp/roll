module Roll.Database.Product
    ( getByCategory
    , getBySlug
    , Slug(getSlug)
    , Product(slug, name, description)
    ) where

import           Roll.Prelude
    hiding ( (^.)
           )

import qualified Roll.Database.Category as Category
import qualified Roll.Database.Internal as I

import qualified Data.Aeson             as Aeson
import qualified Database.Esqueleto     as E
import           Database.Esqueleto
    ( (==.)
    , (^.)
    )
import qualified Database.Persist.Class as Db
import qualified Servant                as Servant

newtype Slug =
    Slug
    { getSlug
          :: String
    }
    deriving newtype ( Aeson.ToJSON, Servant.FromHttpApiData )

data Product =
    Product
    { slug
          :: Slug
    , name
          :: Text
    , price
          :: Int
    , description
          :: Maybe Text
    }
    deriving stock Generic
    deriving anyclass ( Aeson.ToJSON )

getByCategory
    :: Category.Slug -> I.SqlQuery [ Product ]
getByCategory categorySlug = fmap go <$> getProductsBySlug
  where
    slug
        :: String
    slug = Category.getSlug categorySlug

    go
        :: ( E.Value String, E.Value Text, E.Value Int, E.Value (Maybe Text) )
        -> Product
    go ( valueSlug, valueName, valuePrice, valueDesc ) =
        Product
        { slug        = Slug (E.unValue valueSlug)
        , name        = E.unValue valueName
        , price       = E.unValue valuePrice
        , description = E.unValue valueDesc
        }

    getProductsBySlug
        :: I.SqlQuery [ ( E.Value String
                        , E.Value Text
                        , E.Value Int
                        , E.Value (Maybe Text)
                        )
                      ]
    getProductsBySlug =
        E.select
        $ E.from
        $ \(product `E.InnerJoin` category) -> do
            E.on (product ^. I.ProductCid ==. category ^. I.CategoryId)
            E.where_ (category ^. I.CategorySlug ==. E.val slug)
            return
                ( product ^. I.ProductSlug
                , product ^. I.ProductName
                , product ^. I.ProductPrice
                , product ^. I.ProductDescription
                )

getBySlug
    :: Slug -> I.SqlQuery (Maybe Product)
getBySlug (Slug slug) = I.mapEntity go <$> Db.getBy (I.UniqueProductSlug slug)
  where
    go
        :: I.Product -> Product
    go product =
        Product
        { slug        = Slug (I.productSlug product)
        , name        = I.productName product
        , price       = I.productPrice product
        , description = I.productDescription product
        }
