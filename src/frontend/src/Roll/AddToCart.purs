module Roll.AddToCart
    ( addToCart
    ) where

import Prelude

import Effect (Effect)
import Simple.JSON (writeJSON)
import Web.HTML (window)
import Web.HTML.Location (setHref)
import Web.HTML.Window (localStorage, location)
import Web.Storage.Storage (setItem)

key :: String
key = "roll-cart-key"

addToCart :: Array String -> Effect Unit
addToCart things = do
    window
        >>= localStorage
        >>= setItem key (writeJSON things)
    window
        >>= location
        >>= setHref "/"
    -- TODO: Do we really want to go home?

