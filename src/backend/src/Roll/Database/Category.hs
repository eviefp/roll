module Roll.Database.Category
    ( getBySlug
    , Name(getName)
    , Slug(getSlug)
    ) where

import           Roll.Prelude

import qualified Roll.Database.Internal as I

import qualified Data.Aeson             as Aeson
import qualified Database.Persist.Class as Db
import qualified Servant                as Servant

newtype Slug =
    Slug
    { getSlug
          :: String
    }
    deriving newtype ( Aeson.ToJSON, Servant.FromHttpApiData )

newtype Name =
    Name
    { getName
          :: Text
    }
    deriving newtype ( Aeson.ToJSON )

getBySlug
    :: Slug -> I.SqlQuery (Maybe Name)
getBySlug (Slug slug) =
    I.mapEntity (Name . I.categoryName) <$> Db.getBy (I.UniqueSlug slug)
