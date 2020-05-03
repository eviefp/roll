module Roll.Component.Hello
    ( component
    ) where

import Prelude

import Halogen as H
import Halogen.HTML as HH

type HTML m = H.ComponentHTML Action () m

data Action = Action

type State = Unit

component :: forall q o m. H.Component HH.HTML q Unit o m
component =
    H.mkComponent
    { initialState: const unit
    , render
    , eval: H.mkEval H.defaultEval
        { handleAction = handleAction
        }
    }

render :: forall m. State -> HTML m
render _ = HH.text "Hello."

handleAction :: forall m o. Action -> H.HalogenM State Action () o m Unit
handleAction = case _ of
    Action -> pure unit
