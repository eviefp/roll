module Roll.API.Component.Hooks.UseSlug
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
import Halogen.Hooks as Hooks
import Roll.Component.Internal as I

newtype UseSlug hooks
    = UseSlug (Hooks.UseEffect (Hooks.UseState (Maybe String) hooks))

derive instance newtypeUseSlug :: Newtype (UseSlug hooks) _

hook :: forall m. MonadAff m => Hooks.Hook m UseSlug (Maybe String)
hook = Hooks.wrap Hooks.do
    slug /\ modifySlug <- Hooks.useState Nothing

    Hooks.useLifecycleEffect do
       value <- liftEffect I.getSlug
       liftEffect $ log $ "got slug:" <> show value
       modifySlug (const value)
       pure Nothing

    Hooks.pure slug

