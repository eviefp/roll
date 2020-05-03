module Roll.API.Quote
    ( Routes
    , handler
    ) where

import           Roll.Prelude
import           Roll.Prelude.API

import qualified Roll.Database    as Db

data Routes route =
    Routes
    { get
          :: route
          :- Summary "Get quote"
          :> Description "Get a random Jon Skeet quote."
          :> Capture "quoteNum" Int
          :> Get '[JSON] Text
    }
    deriving stock Generic

handler
    :: Routes RollT
handler = Routes { get = getQuote }

getQuote
    :: Int -> RollM Text
getQuote mod = go mod <$> Db.run Db.getQuotes
  where
    go
        :: Int -> [ Text ] -> Text
    go _ []       = "No quotes!"
    go 0 (x : _)  = x
    go m (x : xs) = go (m - 1) (xs ++ [ x ])
