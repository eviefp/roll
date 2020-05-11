module Roll.API.Component.Hook.UseSlug
    ( UseSlug (..)
    , hook
    ) where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype)
import Data.Tuple.Nested ((/\))
import Effect.Aff.Class (class MonadAff)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Halogen.Hooks as Hook
import Roll.Component.Internal as I

newtype UseSlug hooks
    = UseSlug (Hook.UseEffect (Hook.UseState (Maybe String) hooks))

derive instance newtypeUseSlug :: Newtype (UseSlug hooks) _

hook :: forall m. MonadAff m => Hook.Hook m UseSlug (Maybe String)
hook = Hook.wrap Hook.do
    slug /\ modifySlug <- Hook.useState Nothing

    Hook.useLifecycleEffect do
       value <- liftEffect I.getSlug
       liftEffect $ log $ "got slug:" <> show value
       modifySlug (const value)
       pure Nothing

    Hook.pure slug

