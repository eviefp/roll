module Roll.Database.ProductVariant.Types
    ( Slug(..)
    ) where

import           Roll.Prelude

import qualified Data.Aeson   as Aeson
import qualified Servant      as Servant

newtype Slug =
    Slug
    { getSlug
          :: String
    }
    deriving newtype ( Aeson.ToJSON, Servant.FromHttpApiData )
