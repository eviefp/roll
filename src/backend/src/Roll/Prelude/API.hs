module Roll.Prelude.API
    ( module Servant.API
    , module Servant.API.Generic
    , module Servant.Server
    , module Servant.Server.Generic
    ) where

import           Servant.API
    ( (:>)
    , Description
    , Get
    , JSON
    , NoContent(..)
    , Summary
    )
import           Servant.API.Generic
    ( (:-)
    , ToServantApi
    )
import           Servant.Server
    ( Server
    )
import           Servant.Server.Generic
    ( AsServer
    , genericServer
    )
