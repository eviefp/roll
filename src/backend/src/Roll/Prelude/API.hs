{-# LANGUAGE UndecidableInstances #-}

module Roll.Prelude.API
    ( module Servant.API
    , module Control.Monad.Except
    , module Servant.API.Generic
    , module Servant.Server
    , module Servant.Server.Generic
    , Servant.err404
    , RollM(..)
    , RollT
    , HTML
    , throwIfEmpty
    ) where

import           Roll.Prelude

import qualified Roll.Environment            as E

import qualified Control.Monad.Base          as Base
import           Control.Monad.Except
    ( throwError
    )
import qualified Control.Monad.Except        as Except
import qualified Control.Monad.IO.Class      as MonadIO
import qualified Control.Monad.Reader        as Reader
import qualified Control.Monad.Trans.Control as Control
import           Network.HTTP.Media
    ( (//)
    , (/:)
    )
import           Servant.API
    ( (:>)
    , Capture
    , Description
    , Get
    , JSON
    , NoContent(..)
    , Summary
    )
import qualified Servant.API.ContentTypes    as ContentTypes
import           Servant.API.Generic
    ( (:-)
    , ToServantApi
    )
import           Servant.Server
    ( Server
    , ServerError
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
                     , Except.MonadError ServerError, Base.MonadBase IO
                     , Control.MonadBaseControl IO )

type RollT = AsServerT RollM

data HTML

instance ContentTypes.Accept HTML where
    contentType _ = "text" // "html" /: ( "charset", "utf-8" )

instance ContentTypes.MimeUnrender HTML ByteString where
    mimeUnrender _ = Right

instance ContentTypes.MimeRender HTML ByteString where
    mimeRender _ = id

throwIfEmpty
    :: [ a ] -> RollM [ a ]
throwIfEmpty =
    \case
        [] -> throwError Servant.err404
        xs -> pure xs
