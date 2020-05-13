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
import Halogen.Hooks as Hooks

newtype UseAPI st hooks
    = UseAPI (Hooks.UseEffect (Hooks.UseState (Maybe st) hooks))

derive instance newtypeUseAPI :: Newtype (UseAPI st hooks) _

hook
    :: forall m st err a
     . MonadAff m
    =>  Eq a
    => (a -> ExceptT err Aff st)
    -> a
    -> Hooks.Hook m (UseAPI st) (Maybe st)
hook api v = Hooks.wrap Hooks.do
    st /\ modifySt <- Hooks.useState Nothing

    Hooks.captures { v } Hooks.useTickEffect do
        value <- liftAff $ runExceptT (api v)
        modifySt (\_ -> hush value)
        pure Nothing

    Hooks.pure st

