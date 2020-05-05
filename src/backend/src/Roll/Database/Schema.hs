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
    sid SupplierId
    name Text
    description Text Maybe

    Primary pid
    UniqueProductSlug slug
|]

