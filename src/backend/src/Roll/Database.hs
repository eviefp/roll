module Roll.Database
    ( newSqlBackend
    , run
    ) where

import           Roll.Prelude

import qualified Roll.Environment            as E

import qualified Control.Monad.IO.Class      as MonadIO
import qualified Control.Monad.Logger        as Logger
import qualified Control.Monad.Reader        as Reader
import qualified Database.Persist.Postgresql as Postgres
import qualified Database.Persist.Sql        as Sql

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
