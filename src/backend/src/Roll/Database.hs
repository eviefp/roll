{-# LANGUAGE NoDeriveAnyClass #-}
{-# LANGUAGE NoStrictData #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE UndecidableInstances #-}

module Roll.Database
    ( newSqlBackend
    , getQuotes
    , run
    , Quote(..)
    ) where

import           Roll.Prelude

import qualified Roll.Database.Schema        as Roll.Schema
import qualified Roll.Environment            as E

import qualified Control.Monad.IO.Class      as MonadIO
import qualified Control.Monad.Logger        as Logger
import qualified Control.Monad.Reader        as Reader
import qualified Database.Persist.Class      as Db
import qualified Database.Persist.Postgresql as Postgres
import qualified Database.Persist.Sql        as Sql
import qualified Database.Persist.TH         as TH
import qualified Database.Persist.Types      as Types

TH.share [ TH.mkPersist TH.sqlSettings ] Roll.Schema.schema

newtype PoolSize =
    PoolSize
    { getPoolSize
          :: Int
    }
    deriving stock Generic

newSqlBackend
    :: Postgres.ConnectionString -> PoolSize -> IO Sql.ConnectionPool
newSqlBackend connectionString (PoolSize size) =
    Logger.runStderrLoggingT
    $ Postgres.createPostgresqlPool connectionString size

run
    :: forall m a
    .  Reader.MonadReader E.Environment m
    => MonadIO.MonadIO m
    => Reader.ReaderT Sql.SqlBackend IO a
    -> m a
run query =
    Reader.asks E.connectionPool
    >>= runPool
  where
    runPool
        :: Sql.ConnectionPool -> m a
    runPool = MonadIO.liftIO . Sql.runSqlPool query

getQuotes
    :: Reader.ReaderT Sql.SqlBackend IO [ Text ]
getQuotes = mapEntity quoteText <$> Db.selectList [] []

mapEntity
    :: Functor f => (a -> b) -> f (Types.Entity a) -> f b
mapEntity f = fmap (f . Types.entityVal)
