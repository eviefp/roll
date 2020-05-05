{-# LANGUAGE NoDeriveAnyClass #-}
{-# LANGUAGE NoStrictData #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE UndecidableInstances #-}

{-# OPTIONS_GHC -Wno-missing-deriving-strategies -Wno-missing-export-lists #-}

module Roll.Database.Internal where

import           Roll.Prelude

import qualified Roll.Database.Schema   as Roll.Schema

import qualified Control.Monad.Reader   as Reader
import qualified Database.Persist.Sql   as Sql
import qualified Database.Persist.TH    as TH
import qualified Database.Persist.Types as Types

TH.share [ TH.mkPersist TH.sqlSettings ] Roll.Schema.schema

type SqlQuery = Reader.ReaderT Sql.SqlBackend IO

mapEntity
    :: Functor f => (a -> b) -> f (Types.Entity a) -> f b
mapEntity f = fmap (f . Types.entityVal)
