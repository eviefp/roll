module Roll.Database.ProductVariant
    ( Slug(getSlug)
    , ProductVariant(slug, name, code, description)
    , Group(work, system, material)
    , getByProduct
    , getPricesByGroup
    ) where

import           Roll.Prelude
    hiding ( (^.)
           )

import qualified Roll.Calculator.Expr               as Expr
import qualified Roll.Calculator.Interpreter        as Interpreter
import qualified Roll.Calculator.Parser             as Parser
import qualified Roll.Database.Internal             as I
import qualified Roll.Database.Product              as Product
import qualified Roll.Database.ProductVariant.Types as T
import           Roll.Database.ProductVariant.Types
    ( Slug(getSlug)
    )

import qualified Data.Aeson                         as Aeson
import qualified Data.Map                           as M
import qualified Database.Esqueleto                 as E
import           Database.Esqueleto
    ( (==.)
    , (^.)
    )
import qualified Text.Megaparsec                    as Parsec

data ProductVariant =
    ProductVariant
    { slug
          :: T.Slug
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
        { slug        = T.Slug (I.productVariantSlug pv)
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
                (productVariant ^. I.ProductVariantPid
                 ==. product ^. I.ProductId)
            E.where_ (product ^. I.ProductSlug ==. E.val slug)
            return productVariant

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
    :: Group String -> M.Map Expr.Identifier Double -> I.SqlQuery (Group Int)
getPricesByGroup input inputs = go . getCode <$> getPriceCodes
  where
    slugs
        :: [ String ]
    slugs = catMaybes [ system input, material input, work input ]

    go
        :: Group Text -> Group Int
    go group =
        let
            statements = traverse' parse group
            -- Unfortunately, these need to be calculated sequentially.
            system'    = interpret inputs <$> system statements
            work'      =
                interpret (union [ Just inputs, system' ]) <$> work statements
            material'  =
                interpret (union [ Just inputs, system', work' ])
                <$> material statements
            in
                Group
                { system   = mkPrice system'
                , work     = mkPrice work'
                , material = mkPrice material'
                }

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
        $ \(product `E.InnerJoin` category `E.InnerJoin` productVariant) -> do
            E.on (product ^. I.ProductCid ==. category ^. I.CategoryId)
            E.on
                (product ^. I.ProductId
                 ==. productVariant ^. I.ProductVariantPid)
            E.where_
                (productVariant ^. I.ProductVariantSlug `E.in_` E.valList slugs)
            return
                ( category ^. I.CategorySlug
                , productVariant ^. I.ProductVariantPriceFormula
                )

traverse'
    :: (a -> Maybe b) -> Group a -> Group b
traverse' f grp =
    Group
    { system   = system grp
          >>= f
    , material = material grp
          >>= f
    , work     = work grp
          >>= f
    }

parse
    :: Text -> Maybe [ Expr.Statement ]
parse = Parsec.parseMaybe Parser.parseProgram

interpret
    :: M.Map Expr.Identifier Double
    -> [ Expr.Statement ]
    -> M.Map Expr.Identifier Double
interpret i = (`Interpreter.eval` i)

union
    :: [ Maybe (M.Map Expr.Identifier Double) ] -> M.Map Expr.Identifier Double
union = fold . catMaybes

mkPrice
    :: Maybe (M.Map Expr.Identifier Double) -> Maybe Int
mkPrice m =
    m
    >>= fmap floor . M.lookup (Expr.Identifier "result")

