module Roll.Database.Quote
    ( get
    , Quote(getQuote)
    ) where

import           Roll.Prelude

import qualified Roll.Database.Internal as I

import qualified Data.Aeson             as Aeson
import qualified Database.Persist.Class as Db

newtype Quote =
    Quote
    { getQuote
          :: Text
    }
    deriving newtype ( Aeson.ToJSON )

get
    :: I.SqlQuery [ Quote ]
get = I.mapEntity (Quote . I.quoteText) <$> Db.selectList [] []
