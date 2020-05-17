module Roll.Database.Product
    ( getByCategory
    , getBySlug
    , getPricesByGroup
    , Slug(getSlug)
    , Product(slug, name, description)
    , Group(work, system, material)
    ) where

import           Roll.Prelude
    hiding ( (^.)
           )

import qualified Roll.Calculator.Expr               as Expr
import qualified Roll.Calculator.Interpreter        as Interpreter
import qualified Roll.Calculator.Parser             as Parser
import qualified Roll.Database.Category             as Category
import qualified Roll.Database.Internal             as I
import qualified Roll.Database.ProductVariant.Types as PV

import qualified Data.Aeson                         as Aeson
import qualified Data.Map                           as M
import qualified Database.Esqueleto                 as E
import           Database.Esqueleto
    ( (!=.)
    , (==.)
    , (^.)
    , (||.)
    )
import qualified Database.Persist.Class             as Db
import qualified Servant                            as Servant
import qualified Text.Megaparsec                    as Parsec

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
                (product ^. I.ProductId
                 ==. relationship ^. I.ProductRelationshipLeft
                 ||. product ^. I.ProductId
                 ==. relationship ^. I.ProductRelationshipRight)
            E.on
                (relationship ^. I.ProductRelationshipRight
                 ==. relProduct ^. I.ProductId
                 ||. relationship ^. I.ProductRelationshipLeft
                 ==. relProduct ^. I.ProductId)
            E.on
                (relProduct ^. I.ProductId
                 ==. relProductVariant ^. I.ProductVariantPid)
            E.where_ (category ^. I.CategorySlug ==. E.val slug)
            E.where_ (product ^. I.ProductId !=. relProduct ^. I.ProductId)
            E.where_
                (relProductVariant ^. I.ProductVariantSlug
                 `E.in_` E.valList slugList
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

data Group a =
    Group
    { system
          :: Maybe a
    , material
          :: Maybe a
    , work
          :: Maybe a
    }
    deriving stock ( Show, Generic, Functor, Foldable, Traversable )
    deriving anyclass ( Aeson.FromJSON, Aeson.ToJSON )

getPricesByGroup
    :: Group String -> I.SqlQuery (Group Int)
getPricesByGroup input = go . getCode <$> getPriceCodes
  where
    go
        :: Group Text -> Group Int
    go group =
        let
            -- TODO: provide height/width as inputs and refactor this mess
            inputs     = M.empty
            statements =
                Group
                { system   = system group
                      >>= Parsec.parseMaybe Parser.parseProgram
                , material = material group
                      >>= Parsec.parseMaybe Parser.parseProgram
                , work     = work group
                      >>= Parsec.parseMaybe Parser.parseProgram
                }
            system'    = (`Interpreter.eval` inputs) <$> system statements
            work'      =
                (`Interpreter.eval` (M.union
                                         inputs
                                         (fromMaybe M.empty system')))
                <$> work statements
            material'  =
                (`Interpreter.eval` (fold
                                     $ catMaybes
                                         [ pure inputs, work', system' ]))
                <$> material statements
            in
                Group
                { system   = floor
                      <$> (system'
                           >>= M.lookup (Expr.Identifier "result"))
                , work     = floor
                      <$> (work'
                           >>= M.lookup (Expr.Identifier "result"))
                , material = floor
                      <$> (material'
                           >>= M.lookup (Expr.Identifier "result"))
                }

    slugs
        :: [ String ]
    slugs = catMaybes [ system input, material input, work input ]

    getCode
        :: [ ( E.Value String, E.Value Text ) ] -> Group Text
    getCode values =
        let
            results = bimap E.unValue E.unValue <$> values
            in
                Group
                { system   = lookup "sisteme" results
                , material = lookup "materiale" results
                , work     = lookup "manopera" results
                }

    getPriceCodes
        :: I.SqlQuery [ ( E.Value String, E.Value Text ) ]
    getPriceCodes =
        E.select
        $ E.from
        $ \(product `E.InnerJoin` category) -> do
            E.on (product ^. I.ProductCid ==. category ^. I.CategoryId)
            E.where_ (product ^. I.ProductSlug `E.in_` E.valList slugs)
            return
                ( category ^. I.CategorySlug
                , product ^. I.ProductPriceFormula
                )
