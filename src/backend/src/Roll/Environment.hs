module Roll.Environment
    ( Environment(connectionPool)
    , readEnvironment
    ) where

import           Roll.Prelude

import qualified Database.Persist.Sql as Sql

data Environment =
    Environment
    { connectionPool
          :: Sql.ConnectionPool
    }
    deriving stock Generic

readEnvironment
    :: Sql.ConnectionPool -> IO Environment
readEnvironment connectionPool =
    pure
    $ Environment { connectionPool }
