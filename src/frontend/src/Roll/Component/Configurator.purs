module Roll.Component.Configurator
    ( component
    ) where

import Prelude

import Control.Monad.Except (runExceptT)
import Data.Array as A
import Data.Either (hush)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Tuple.Nested ((/\))
import Effect.Aff.Class (class MonadAff)
import Halogen as H
import Halogen.HTML as HH
import Halogen.Hooks as Hooks
import Roll.API.Component.Hook.CategoryView as CategoryView
import Roll.API.Component.Hook.NumericInput as NumericInput
import Roll.API.Configurator as Configurator

type HTML m = H.ComponentHTML (Hooks.HookM m Unit) () m

emptyOutput :: Configurator.Output Int
emptyOutput =
    { system: Nothing
    , material: Nothing
    , work: Nothing
    }

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

    system /\ systemOptions /\ updateSystem /\ renderSystem
        <- CategoryView.hook "sisteme" "Sisteme"
    material /\ materialOptions /\ updateMaterial /\ renderMaterial
        <- CategoryView.hook "materiale" "Materiale"
    work /\ workOptions /\ updateWork /\ renderWork
        <- CategoryView.hook "manopera" "Manopera"

    price /\ modifyPrice <- Hooks.useState emptyOutput

    Hooks.captures {system, material, work} Hooks.useTickEffect do
       let slugs = A.catMaybes [ system, material, work ]
       updateSystem slugs
       updateMaterial slugs
       updateWork slugs
       if A.length slugs == 3
            then
                case width, height of
                    Just latime, Just inaltime ->
                        let mkInput =
                                { groups: { system, material, work }
                                , inputs: { inaltime, latime}
                                }
                        in (H.liftAff
                               $ runExceptT
                               $ Configurator.calculatePrice mkInput)
                            >>= modifyPrice
                                    <<< const
                                    <<< fromMaybe emptyOutput
                                    <<< hush
                    _, _ -> mempty
            else mempty
       pure Nothing

    let
        renderWidthHeight :: Array (HTML m)
        renderWidthHeight =
            [ renderWidth unit
            , renderHeight unit
            ]


        renderDebug ::  Array (HTML m)
        renderDebug =
            [ HH.text $ show
                { width
                , height
                , system
                , material
                , work
                , systemOptions
                , materialOptions
                , workOptions
                , price
                }
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

