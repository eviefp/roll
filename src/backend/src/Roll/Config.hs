module Roll.Config
    ( Config(..)
    , DatabaseConfig(..)
    , HttpConfig(..)
    , read
    ) where

import           Roll.Prelude

import qualified Data.Aeson       as Aeson
import qualified Data.Word        as Word
import qualified Data.Yaml.Config as Yaml

data Config =
    Config
    { database
          :: DatabaseConfig
    , http
          :: HttpConfig
    }
    deriving stock Generic
    deriving anyclass ( Aeson.ToJSON, Aeson.FromJSON )

data DatabaseConfig =
    DatabaseConfig
    { hostname
          :: String
    , port
          :: Word.Word16
    , username
          :: String
    , password
          :: String
    , dbName
          :: String
    }
    deriving stock Generic
    deriving anyclass ( Aeson.ToJSON, Aeson.FromJSON )

data HttpConfig =
    HttpConfig
    { httpPort
          :: Int
    , staticContentPath
          :: FilePath
    }
    deriving stock Generic
    deriving anyclass ( Aeson.ToJSON, Aeson.FromJSON )

read
    :: IO Config
read = Yaml.loadYamlSettings [ "roll.yaml" ] [] Yaml.useEnv
