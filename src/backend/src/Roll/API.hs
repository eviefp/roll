module Roll.API
    ( Routes
    , handler
    , RollM(..)
    , RollT
    ) where

import           Roll.Prelude
import           Roll.Prelude.API

import qualified Roll.API.Category      as Category
import qualified Roll.API.CategoryRoute as CategoryRoute
import qualified Roll.API.Dev           as Dev
import qualified Roll.API.Quote         as Quote
import qualified Roll.API.Static        as Static

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
    , static
          :: route
          :- Static.API
    }
    deriving stock Generic

handler
    :: Routes RollT
handler =
    Routes
    { dev           = genericServerT Dev.handler
    , quote         = genericServerT Quote.handler
    , category      = genericServerT Category.handler
    , categoryRoute = genericServerT CategoryRoute.handler
    , static        = Static.handler
    }
