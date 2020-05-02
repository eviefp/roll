module Roll
    ( startApp
    ) where

import           Roll.Prelude
import           Roll.Prelude.API

import qualified Control.Monad.IO.Class      as MonadIO
import qualified Control.Monad.Logger        as Logger
import qualified Control.Monad.Reader        as Reader

import qualified Database.Persist.Postgresql as Postgresql
import qualified Database.PostgreSQL.Simple  as PG

import qualified Network.Wai.Handler.Warp    as Warp

import qualified Servant                     as Servant
import qualified Servant.Server.Generic      as GServant

import qualified Roll.API                    as RollAPI
import qualified Roll.Environment            as E

startApp
    :: IO ()
startApp =
    do
    Logger.runStderrLoggingT
        $ Postgresql.withPostgresqlPool connectionString 10
        $ \connectionPool -> do
        env <- MonadIO.liftIO
            $ E.readEnvironment connectionPool
        MonadIO.liftIO
            $ Warp.run 8080
            $ GServant.genericServeT (hoist env) RollAPI.handler
  where
    hoist
        :: E.Environment
        -> RollAPI.RollM a
        -> Servant.Handler a
    hoist env =
        (`Reader.runReaderT` env)
        . unRollM

    connectionString =
        PG.postgreSQLConnectionString connectionInfo

    connectionInfo =
        PG.defaultConnectInfo
        { PG.connectUser     = "roll"
        , PG.connectPassword = "roll"
        , PG.connectDatabase = "roll"
        }

