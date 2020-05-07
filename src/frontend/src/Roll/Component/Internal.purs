module Roll.Component.Internal
    ( maybeElement
    , getSlug
    ) where

import Prelude

import Control.Monad.Except (ExceptT(..))
import Data.Either (note)
import Data.Maybe (Maybe(..), maybe)
import Data.Maybe.Last as Maybe
import Data.Newtype (unwrap)
import Data.String as S
import Data.Traversable (foldMap)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Halogen.HTML as HH
import Roll.API.Internal (Error(..))
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

getSlug :: ExceptT Error Aff String
getSlug = ExceptT $ note UnknownError <<< go <$> liftEffect href
  where
    go :: String -> Maybe String
    go = unwrap <<< foldMap (Maybe.Last <<< Just) <<< S.split (S.Pattern "/")

href :: Effect String
href = HTML.window >>= Window.location >>= Location.href

