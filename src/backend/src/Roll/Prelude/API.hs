{-# LANGUAGE UndecidableInstances #-}

module Roll.Prelude.API
    ( module Servant.API
    , module Servant.API.Generic
    , module Servant.Server
    , module Servant.Server.Generic
    , RollM(..)
    , RollT
    ) where

import           Roll.Prelude

import qualified Roll.Environment            as E

import qualified Control.Monad.Base          as Base
import qualified Control.Monad.IO.Class      as MonadIO
import qualified Control.Monad.Reader        as Reader
import qualified Control.Monad.Trans.Control as Control
import           Servant.API
    ( (:>)
    , Capture
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
    , ServerT
    )
import qualified Servant.Server              as Servant
import           Servant.Server.Generic
    ( AsServer
    , AsServerT
    , genericServer
    , genericServerT
    )

newtype RollM a =
    RollM
    { unRollM
          :: Reader.ReaderT E.Environment Servant.Handler a
    }
    deriving newtype ( Functor, Applicative, Monad
                     , Reader.MonadReader E.Environment, MonadIO.MonadIO
                     , Base.MonadBase IO, Control.MonadBaseControl IO )

type RollT = AsServerT RollM
