module Roll.API.Component.Hook.UseAPI
    ( UseAPI (..)
    , hook
    ) where

import Prelude

import Control.Monad.Except (ExceptT, runExceptT)
import Data.Either (hush)
import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype)
import Data.Tuple.Nested ((/\))
import Effect.Aff (Aff)
import Effect.Aff.Class (class MonadAff, liftAff)
import Halogen.Hooks as Hook
import Halogen.Hooks.Hook (Hook)
import Roll.API.Internal (Error)
import Type.Prelude (Proxy)

newtype UseAPI st hooks
    = UseAPI (Hook.UseEffect (Hook.UseState (Maybe st) hooks))

derive instance newtypeUseAPI :: Newtype (UseAPI st hooks) _

hook
    :: forall m st
     . MonadAff m
    => Proxy st
    -> ExceptT Error Aff st
    -> Hook m (UseAPI st) (Maybe st)
hook _ api = Hook.wrap Hook.do
    st /\ modifySt <- Hook.useState Nothing

    Hook.useLifecycleEffect do
        value <- liftAff $ runExceptT api
        modifySt (\_ -> hush value)
        pure Nothing

    Hook.pure st

