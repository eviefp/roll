module Roll.Database.Category
    ( getBySlug
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

getBySlug
    :: Slug -> I.SqlQuery (Maybe Text)
getBySlug (Slug slug) =
    I.mapEntity I.categoryName <$> Db.getBy (I.UniqueCategorySlug slug)
