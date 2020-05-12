module Roll.Database.Category
    ( getBySlug
    , getByProductVariantSlug
    , Slug(getSlug)
    , Category(slug, name)
    ) where

import           Roll.Prelude
    hiding ( (^.)
           )

import qualified Roll.Database.Internal             as I
import qualified Roll.Database.ProductVariant.Types as ProductVariant

import qualified Data.Aeson                         as Aeson
import qualified Database.Esqueleto                 as E
import           Database.Esqueleto
    ( (==.)
    , (^.)
    )
import qualified Database.Persist.Class             as Db
import qualified Servant                            as Servant

newtype Slug =
    Slug
    { getSlug
          :: String
    }
    deriving newtype ( Aeson.ToJSON, Servant.FromHttpApiData )

data Category =
    Category
    { slug
          :: Slug
    , name
          :: Text
    }
    deriving stock Generic
    deriving anyclass ( Aeson.ToJSON )

getBySlug
    :: Slug -> I.SqlQuery (Maybe Text)
getBySlug (Slug slug) =
    I.mapEntity I.categoryName <$> Db.getBy (I.UniqueCategorySlug slug)

getByProductVariantSlug
    :: ProductVariant.Slug -> I.SqlQuery (Maybe Category)
getByProductVariantSlug
    pvSlug = fmap (go . E.entityVal) . listToMaybe <$> getProductByVariantSlug
  where
    slug
        :: String
    slug = ProductVariant.getSlug pvSlug

    go
        :: I.Category -> Category
    go cat =
        Category
        { slug = Slug (I.categorySlug cat)
        , name = I.categoryName cat
        }

    getProductByVariantSlug
        :: I.SqlQuery [ E.Entity I.Category ]
    getProductByVariantSlug =
        do
            E.select
        $ E.from
        $ \(productVariant `E.InnerJoin` product `E.InnerJoin` category) -> do
            E.on
                (productVariant
                 ^. I.ProductVariantPid ==. product
                 ^. I.ProductId)
            E.on (product ^. I.ProductCid ==. category ^. I.CategoryId)
            E.where_ (productVariant ^. I.ProductVariantSlug ==. E.val slug)
            return category
