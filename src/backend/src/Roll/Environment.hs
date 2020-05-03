module Roll.Environment
    ( Environment(connectionPool)
    , read
    ) where

import           Roll.Prelude

import qualified Roll.Config          as Config

import qualified Database.Persist.Sql as Sql

data Environment =
    Environment
    { connectionPool
          :: Sql.ConnectionPool
    , staticContentPath
          :: FilePath
    }
    deriving stock Generic

read
    :: Config.Config -> Sql.ConnectionPool -> IO Environment
read config connectionPool =
    pure
    $ Environment
    { connectionPool
    , staticContentPath = config ^. field @"http" . field @"staticContentPath"
    }
