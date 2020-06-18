module Roll.Component.Internal
    ( maybeElement
    , whenElement
    , getSlug
    , loading
    , emptyElement
    , whenProperty
    , maybeProperty
    , emptyProperty
    ) where

import Prelude

import Data.Maybe (Maybe(..), maybe)
import Data.Maybe.Last as Maybe
import Data.Newtype (unwrap)
import Data.String as S
import Data.Traversable (foldMap)
import Effect (Effect)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Web.HTML as HTML
import Web.HTML.Location as Location
import Web.HTML.Window as Window

maybeElement
    :: forall p i a
    .  Maybe a
    -> (a -> HH.HTML p i)
    -> HH.HTML p i
maybeElement m f = maybe emptyElement f m

whenElement :: forall p i. Boolean -> (Unit -> HH.HTML p i) -> HH.HTML p i
whenElement cond f = if cond then f unit else emptyElement

emptyElement :: forall w i. HH.HTML w i
emptyElement = HH.text ""

getSlug :: Effect (Maybe String)
getSlug = go <$> href
  where
    go :: String -> Maybe String
    go = unwrap <<< foldMap (Maybe.Last <<< Just) <<< S.split (S.Pattern "/")

href :: Effect String
href = HTML.window >>= Window.location >>= Location.href

maybeProperty :: forall p i a. Maybe a -> (a -> HH.IProp p i) -> HH.IProp p i
maybeProperty m f = maybe emptyProperty f m

whenProperty :: forall p i. Boolean -> (Unit -> HH.IProp p i) -> HH.IProp p i
whenProperty cond f = if cond then f unit else emptyProperty

emptyProperty :: forall p i. HH.IProp p i
emptyProperty = HP.attr (H.AttrName "data-ignore") "ignore"

loading :: forall p i. HH.HTML p i
loading = HH.text "loading..."

