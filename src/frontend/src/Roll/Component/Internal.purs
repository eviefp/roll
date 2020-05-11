module Roll.Component.Internal
    ( maybeElement
    , getSlug
    , loading
    , hpure
    ) where

import Prelude

import Data.Maybe (Maybe(..), maybe)
import Data.Maybe.Last as Maybe
import Data.Newtype (unwrap)
import Data.String as S
import Data.Traversable (foldMap)
import Effect (Effect)
import Halogen.HTML as HH
import Halogen.Hooks as Hooks
import Unsafe.Coerce (unsafeCoerce)
import Web.HTML as HTML
import Web.HTML.Location as Location
import Web.HTML.Window as Window

maybeElement
    :: forall p i a
    .  Maybe a
    -> (a -> HH.HTML p i)
    -> HH.HTML p i
maybeElement m f = maybe emptyElement f m

emptyElement :: forall w i. HH.HTML w i
emptyElement = HH.text ""

getSlug :: Effect (Maybe String)
getSlug = go <$> href
  where
    go :: String -> Maybe String
    go = unwrap <<< foldMap (Maybe.Last <<< Just) <<< S.split (S.Pattern "/")

href :: Effect String
href = HTML.window >>= Window.location >>= Location.href

loading :: forall p i. HH.HTML p i
loading = HH.text "loading..."

hpure :: forall m a hook. a -> Hooks.Hook m hook a
hpure a = unsafeCoerce go
  where
    go :: forall h. Hooks.Hooked m (hook h) (hook h) a
    go = Hooks.pure a
