{-# LANGUAGE NoDeriveAnyClass #-}
{-# LANGUAGE NoStrictData #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}

module Roll.Database.Schema
    ( schema
    ) where

import           Roll.Prelude

import           Database.Persist.TH
    ( persistLowerCase
    )
import           Database.Persist.Types
    ( EntityDef
    )

schema
    :: [ EntityDef ]
schema =
    [persistLowerCase|
Quote
    qid Int
    text Text

    Primary qid

Category
    cid Int
    slug String
    name Text

    Primary cid
    UniqueCategorySlug slug

Supplier
    sid Int
    name Text
    url Text
    description Text Maybe

    Primary sid

Product
    pid Int
    slug String
    cid CategoryId
    sid SupplierId Maybe
    name Text
    price Int
    description Text Maybe

    Primary pid
    UniqueProductSlug slug

ProductVariant
    pvid Int
    pid ProductId
    slug String
    name Text
    code Text
    price Int
    description Text Maybe

    Primary pvid
    UniqueProductVariantSlug slug
    UniqueProductVariantCode code

ProductRelationship
    prid Int
    left ProductId
    right ProductId

    Primary prid
    UniqueProductRelationshipLR left right

Option
    oid Int
    name Text
    description Text

    Primary oid

OptionItem
    oiid Int
    oid OptionId
    name Text

    Primary oiid

ProductOption
    poid Int
    pid ProductId
    oid OptionId

    Primary poid
|]

