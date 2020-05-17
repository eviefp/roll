module Roll.API.Configurator
    ( Routes
    , handler
    ) where

import           Roll.Prelude
import           Roll.Prelude.API

import qualified Roll.Database         as Db
import qualified Roll.Database.Product as Product

newtype Routes route =
    Routes
    { price
          :: route
          :- Summary "Calculate price"
          :> Description "Calculate price for product group."
          :> ReqBody '[JSON] (Product.Group String)
          :> Put '[JSON] (Product.Group Int)
    }
    deriving stock Generic

handler
    :: Routes RollT
handler = Routes { price = calculatePrice }

calculatePrice
    :: Product.Group String -> RollM (Product.Group Int)
calculatePrice = Db.run . Product.getPricesByGroup
