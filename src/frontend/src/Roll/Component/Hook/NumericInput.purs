module Roll.API.Component.Hook.NumericInput
    ( NumericInput(..)
    , hook
    ) where

import Prelude

import Data.Int as Int
import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype)
import Data.Number as Number
import Data.Tuple.Nested ((/\), type (/\))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Halogen.Hooks as Hooks

type HTML m = H.ComponentHTML (Hooks.HookM m Unit) () m

type HookComponent m a = a /\ (Unit -> HTML m)

newtype NumericInput hooks = NumericInput (Hooks.UseState (Maybe Int) hooks)

derive instance newtypeNumericInput :: Newtype (NumericInput hooks) _

type Input =
    { id   :: String
    , text :: String
    , min  :: Number
    , max  :: Number
    }

hook
    :: forall m
     . Input
    -> Hooks.Hook m NumericInput (HookComponent m (Maybe Int))
hook { id, text, min, max } = Hooks.wrap Hooks.do
    st /\ modifySt <- Hooks.useState Nothing
    let
        update
            :: String
            -> Hooks.HookM m Unit
        update = modifySt <<< const <<< map Int.ceil <<< Number.fromString

        render :: Unit -> HTML m
        render _ =
            HH.fieldset_
                [ HH.label
                    [ HP.for id
                    ]
                    [ HH.text text
                    ]
                , HH.input
                    [ HP.type_ HP.InputNumber
                    , HP.min min
                    , HP.max max
                    , HP.id_ id
                    , HE.onValueInput (Just <<< update)
                    ]
                ]
    Hooks.pure $ st /\ render

