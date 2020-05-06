module Roll.Component.Internal
    ( maybeElement
    ) where

import Data.Maybe (Maybe, maybe)
import Halogen.HTML as HH


maybeElement
    :: forall p i a
    .  Maybe a
    -> (a -> HH.HTML p i)
    -> HH.HTML p i
maybeElement m f = maybe emptyElement f m

emptyElement :: forall w i. HH.HTML w i
emptyElement = HH.text ""
