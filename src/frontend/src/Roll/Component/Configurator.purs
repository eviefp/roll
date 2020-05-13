module Roll.Component.Configurator
    ( component
    ) where

import Prelude

import Data.Tuple.Nested ((/\))
import Effect.Aff.Class (class MonadAff)
import Halogen as H
import Halogen.HTML as HH
import Halogen.Hooks as Hooks
import Roll.API.Component.Hook.CategoryView as CategoryView
import Roll.API.Component.Hook.NumericInput as NumericInput

type HTML m = H.ComponentHTML (Hooks.HookM m Unit) () m

component :: forall q o m. MonadAff m => H.Component HH.HTML q Unit o m
component = Hooks.component \_ _ -> Hooks.do
    width /\ renderWidth <-
        NumericInput.hook
            { id: "askWidth"
            , text: "Latime (cm):"
            , min: 100.0
            , max: 700.0
            }
    height /\ renderHeight <-
        NumericInput.hook
            { id: "askHeight"
            , text: "Inaltime (cm):"
            , min: 100.0
            , max: 700.0
            }

    system /\ renderSystem <- CategoryView.hook "sisteme" "Sisteme"
    material /\ renderMaterial <- CategoryView.hook "materiale" "Materiale"
    work /\ renderWork <- CategoryView.hook "manopera" "Manopera"


    let
        renderWidthHeight :: Array (HTML m)
        renderWidthHeight =
            [ renderWidth unit
            , renderHeight unit
            ]


        renderDebug ::  Array (HTML m)
        renderDebug =
            [ HH.text $ show { width, height, system, material, work }
            ]

        render :: HTML m
        render =
            HH.div_
                [ HH.section_ renderWidthHeight
                , renderSystem unit
                , renderMaterial unit
                , renderWork unit
                , HH.section_ renderDebug
                ]

    Hooks.pure render

