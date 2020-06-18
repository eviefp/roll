module Roll
    ( startApp
    ) where

import           Roll.Prelude
import           Roll.Prelude.API

import qualified Roll.API                    as RollAPI
import qualified Roll.Config                 as Config
import qualified Roll.Environment            as E

import qualified Control.Monad.IO.Class      as MonadIO
import qualified Control.Monad.Logger        as Logger
import qualified Control.Monad.Reader        as Reader
import qualified Data.ByteString             as BS
import qualified Database.Persist.Postgresql as Postgresql
import qualified Database.PostgreSQL.Simple  as PG
import qualified Network.Wai.Handler.Warp    as Warp
import qualified Servant                     as Servant
import qualified Servant.Server.Generic      as GServant

startApp
    :: FilePath -> IO ()
startApp configPath =
    do
        config <- Config.read configPath
        Logger.runStderrLoggingT
            . Postgresql.withPostgresqlPool (connectionString config) 10
            $ \connectionPool -> do
                env <- MonadIO.liftIO
                    $ E.read config connectionPool
                MonadIO.liftIO
                    . Warp.run (config ^. field @"http" . field @"httpPort")
                    $ GServant.genericServeT (hoist env) RollAPI.handler
  where
    hoist
        :: E.Environment -> RollAPI.RollM a -> Servant.Handler a
    hoist env (RollM rollM) = rollM `Reader.runReaderT` env

    connectionString
        :: Config.Config -> BS.ByteString
    connectionString config =
        PG.postgreSQLConnectionString (connectInfo config)

    connectInfo
        :: Config.Config -> PG.ConnectInfo
    connectInfo config =
        PG.defaultConnectInfo
        { PG.connectHost     = config ^. field @"database" . field @"hostname"
        , PG.connectPort     = config ^. field @"database" . field @"port"
        , PG.connectUser     = config ^. field @"database" . field @"username"
        , PG.connectPassword = config ^. field @"database" . field @"password"
        , PG.connectDatabase = config ^. field @"database" . field @"dbName"
        }

