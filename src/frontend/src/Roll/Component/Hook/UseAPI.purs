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

newtype UseAPI st hooks
    = UseAPI (Hook.UseEffect (Hook.UseState (Maybe st) hooks))

derive instance newtypeUseAPI :: Newtype (UseAPI st hooks) _

hook
    :: forall m st err a
     . MonadAff m
    =>  Eq a
    => (a -> ExceptT err Aff st)
    -> a
    -> Hook m (UseAPI st) (Maybe st)
hook api v = Hook.wrap Hook.do
    st /\ modifySt <- Hook.useState Nothing

    Hook.captures { v } Hook.useTickEffect do
        value <- liftAff $ runExceptT (api v)
        modifySt (\_ -> hush value)
        pure Nothing

    Hook.pure st

