module Roll.API.Configurator
    ( Routes
    , handler
    ) where

import           Roll.Prelude
import           Roll.Prelude.API

import qualified Roll.Calculator.Expr         as Expr
import qualified Roll.Database                as Db
import qualified Roll.Database.ProductVariant as ProductVariant

import qualified Data.Aeson                   as Aeson
import qualified Data.Map                     as M

newtype Routes route =
    Routes
    { price
          :: route
          :- Summary "Calculate price"
          :> Description "Calculate price for product variant group."
          :> ReqBody '[JSON] Input
          :> Put '[JSON] (ProductVariant.Group Int)
    }
    deriving stock Generic

data Input =
    Input
    { groups
          :: ProductVariant.Group String
    , inputs
          :: M.Map Expr.Identifier Double
    }
    deriving stock ( Generic )
    deriving anyclass ( Aeson.FromJSON )

handler
    :: Routes RollT
handler = Routes { price = calculatePrice }

calculatePrice
    :: Input -> RollM (ProductVariant.Group Int)
calculatePrice Input{ groups, inputs } =
    Db.run
    $ ProductVariant.getPricesByGroup groups inputs
