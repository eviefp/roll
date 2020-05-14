module Roll.API
    ( Routes
    , handler
    , RollM(..)
    , RollT
    ) where

import           Roll.Prelude
import           Roll.Prelude.API

import qualified Roll.API.Category          as Category
import qualified Roll.API.CategoryRoute     as CategoryRoute
import qualified Roll.API.ConfiguratorRoute as ConfiguratorRoute
import qualified Roll.API.Dev               as Dev
import qualified Roll.API.ProductOption     as ProductOption
import qualified Roll.API.ProductRoute      as ProductRoute
import qualified Roll.API.ProductVariant    as ProductVariant
import qualified Roll.API.Quote             as Quote
import qualified Roll.API.Static            as Static

data Routes route =
    Routes
    { dev
          :: route
          :- "dev"
          :> ToServantApi Dev.Routes
    , quote
          :: route
          :- "quote"
          :> ToServantApi Quote.Routes
    , category
          :: route
          :- "category"
          :> ToServantApi Category.Routes
    , categoryRoute
          :: route
          :- "categorie"
          :> ToServantApi CategoryRoute.Routes
    , product
          :: route
          :- "product"
          :> ToServantApi ProductVariant.Routes
    , option
          :: route
          :- "option"
          :> ToServantApi ProductOption.Routes
    , productRoute
          :: route
          :- "produs"
          :> ToServantApi ProductRoute.Routes
    , configuratorRoute
          :: route
          :- "configurator"
          :> ToServantApi ConfiguratorRoute.Routes
    , static
          :: route
          :- Static.API
    }
    deriving stock Generic

handler
    :: Routes RollT
handler =
    Routes
    { dev               = genericServerT Dev.handler
    , quote             = genericServerT Quote.handler
    , category          = genericServerT Category.handler
    , categoryRoute     = genericServerT CategoryRoute.handler
    , product           = genericServerT ProductVariant.handler
    , option            = genericServerT ProductOption.handler
    , productRoute      = genericServerT ProductRoute.handler
    , configuratorRoute = genericServerT ConfiguratorRoute.handler
    , static            = Static.handler
    }
