module Roll.Database.Product
    ( getByCategory
    , getBySlug
    , Slug(getSlug)
    , Product(slug, name, description)
    ) where

import           Roll.Prelude
    hiding ( (^.)
           )

import qualified Roll.Database.Category             as Category
import qualified Roll.Database.Internal             as I
import qualified Roll.Database.ProductVariant.Types as PV

import qualified Data.Aeson                         as Aeson
import qualified Database.Esqueleto                 as E
import           Database.Esqueleto
    ( (!=.)
    , (==.)
    , (^.)
    , (||.)
    )
import qualified Database.Persist.Class             as Db
import qualified Servant                            as Servant

newtype Slug =
    Slug
    { getSlug
          :: String
    }
    deriving newtype ( Aeson.ToJSON, Aeson.FromJSON, Servant.FromHttpApiData )

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
    :: Category.Slug -> [ PV.Slug ] -> I.SqlQuery [ Product ]
getByCategory categorySlug slugs =
    fmap (go . E.entityVal) <$> getProductsBySlug
  where
    slug
        :: String
    slug = Category.getSlug categorySlug

    slugList
        :: [ String ]
    slugList = PV.getSlug <$> slugs

    go
        :: I.Product -> Product
    go p =
        Product
        { slug        = Slug (I.productSlug p)
        , name        = I.productName p
        , price       = I.productPrice p
        , description = I.productDescription p
        }

    getProductsBySlug
        :: I.SqlQuery [ E.Entity I.Product ]
    getProductsBySlug =
        E.select
        $ E.distinct
        $ E.from
        $ \(product
            `E.InnerJoin` category
            `E.InnerJoin` relationship
            `E.InnerJoin` relProduct
            `E.InnerJoin` relProductVariant) -> do
            E.on (product ^. I.ProductCid ==. category ^. I.CategoryId)
            E.on
                (product
                 ^. I.ProductId ==. relationship
                 ^. I.ProductRelationshipLeft ||. product
                 ^. I.ProductId ==. relationship
                 ^. I.ProductRelationshipRight)
            E.on
                (relationship
                 ^. I.ProductRelationshipRight ==. relProduct
                 ^. I.ProductId ||. relationship
                 ^. I.ProductRelationshipLeft ==. relProduct
                 ^. I.ProductId)
            E.on
                (relProduct
                 ^. I.ProductId ==. relProductVariant
                 ^. I.ProductVariantPid)
            E.where_ (category ^. I.CategorySlug ==. E.val slug)
            E.where_ (product ^. I.ProductId !=. relProduct ^. I.ProductId)
            E.where_
                (relProductVariant
                 ^. I.ProductVariantSlug `E.in_` E.valList slugList
                 ||. E.val (null slugList))
            return product

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
