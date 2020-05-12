module Roll.Component.Configurator
    ( component
    ) where

import Prelude

import Data.Int (ceil)
import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))
import Effect.Aff.Class (class MonadAff)
import Global (readInt)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Halogen.Hooks as Hooks
import Type.Row (type (+))

type Width r = ( width :: Int | r )
type Height r = ( height :: Int | r )
type System r = ( system :: String | r )
type Material r = ( material :: String | r )
type Work r = ( work :: String | r )

data State
    = AskWidth
    | AskHeight (Record (Width + ()))
    | AskSystem (Record (Width + Height + ()))
    | AskMaterial (Record (Width + Height + System + ()))
    | AskWork (Record (Width + Height + System + Material + ()))
    | Calculate (Record (Width + Height + System + Material + Work + ()))

component :: forall q o m. MonadAff m => H.Component HH.HTML q Unit o m
component = Hooks.component \_ _ -> Hooks.do
    state /\ modifyState <- Hooks.useState AskWidth
    tmp /\ modifyTmp <- Hooks.useState ""
    Hooks.pure $ render modifyTmp (modifyState (stateTransition tmp)) state

stateTransition
    :: String
    -> State
    -> State
stateTransition val = case _ of
    AskWidth    -> AskHeight { width: ceil $ readInt 10 val }
    AskHeight x -> AskHeight x
    _           -> AskWidth

render
    :: forall p m
     . ((String -> String) -> Hooks.HookM m Unit)
    -> Hooks.HookM m Unit
    -> State
    -> HH.HTML p (Hooks.HookM m Unit)
render modifyTmp next = case _ of
    AskWidth -> renderAskWidth modifyTmp next
    AskHeight r -> HH.text $ show r.width
    _ -> HH.text "wat"

renderAskWidth
    :: forall p m
     . ((String -> String) -> Hooks.HookM m Unit)
    -> Hooks.HookM m Unit
    -> HH.HTML p (Hooks.HookM m Unit)
renderAskWidth modify next =
    HH.div_
        [ HH.label
            [ HP.for "askWidth"
            ]
            [ HH.text "Latime (cm): "
            ]
        , HH.input
            [ HP.type_ HP.InputNumber
            , HP.min 100.0
            , HP.max 700.0
            , HP.value "200"
            , HP.id_ "askWidth"
            , HE.onValueChange (\s -> Just (modify (const s)))
            ]
        , HH.button
            [ HE.onClick (const (Just next))
            ]
            [ HH.text "next"
            ]
        ]
