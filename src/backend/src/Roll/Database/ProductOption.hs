module Roll.Database.ProductOption
    ( Option(name, description, options)
    , OptionItem(getOptionItem)
    , getByProductSlug
    ) where

import           Roll.Prelude
    hiding ( (^.)
           )

import qualified Roll.Database.Internal as I
import qualified Roll.Database.Product  as Product

import qualified Data.Aeson             as Aeson
import qualified Data.List              as L
import qualified Database.Esqueleto     as E
import           Database.Esqueleto
    ( (==.)
    , (^.)
    )

data Option =
    Option
    { name
          :: Text
    , description
          :: Text
    , options
          :: [ OptionItem ]
    }
    deriving stock Generic
    deriving anyclass ( Aeson.ToJSON )

newtype OptionItem =
    OptionItem
    { getOptionItem
          :: Text
    }
    deriving newtype ( Aeson.ToJSON )

getByProductSlug
    :: Product.Slug -> I.SqlQuery [ Option ]
getByProductSlug productSlug = go <$> getOptions
  where
    slug
        :: String
    slug = Product.getSlug productSlug

    go
        :: [ ( E.Value (E.Key I.Option)
             , E.Value Text
             , E.Value Text
             , E.Value Text
             )
           ]
        -> [ Option ]
    go =
        catMaybes
        . fmap arrayToOption
        . L.groupBy (\( k1, _, _, _ ) ( k2, _, _, _ ) -> k1 == k2)
        . fmap unValue

    arrayToOption
        :: [ ( Int, Text, Text, Text ) ] -> Maybe Option
    arrayToOption []                                      = Nothing
    arrayToOption items@(( _, name, description, _ ) : _) =
        Just Option { name, description, options = mkOptions <$> items }

    mkOptions
        :: ( Int, Text, Text, Text ) -> OptionItem
    mkOptions ( _, _, _, name ) = OptionItem name

    unValue
        :: ( E.Value (E.Key I.Option)
           , E.Value Text
           , E.Value Text
           , E.Value Text
           )
        -> ( Int, Text, Text, Text )
    unValue ( key, name, desc, iname ) =
        ( I.unOptionKey (E.unValue key)
        , E.unValue name
        , E.unValue desc
        , E.unValue iname
        )

    getOptions
        :: I.SqlQuery [ ( E.Value (E.Key I.Option)
                        , E.Value Text
                        , E.Value Text
                        , E.Value Text
                        )
                      ]
    getOptions =
        E.select
        $ E.from
        $ \(product
            `E.InnerJoin` productOption
            `E.InnerJoin` option
            `E.InnerJoin` optionItem) -> do
            E.on
                (product ^. I.ProductId ==. productOption ^. I.ProductOptionPid)
            E.on (productOption ^. I.ProductOptionOid ==. option ^. I.OptionId)
            E.on (option ^. I.OptionId ==. optionItem ^. I.OptionItemOid)
            E.where_ (product ^. I.ProductSlug ==. E.val slug)
            return
                ( option ^. I.OptionId
                , option ^. I.OptionName
                , option ^. I.OptionDescription
                , optionItem ^. I.OptionItemName
                )
