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
|]

