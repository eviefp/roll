module Roll.NewComponents.Configurator
    ( component
    ) where

import Prelude

import Data.Int as Int
import Data.Lens ((.=))
import Data.Lens as Lens
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Number as Number
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Roll.API.Category as Category
import Roll.API.ProductVariant as ProductVariant
import Roll.Capability.Category (class MonadCategory)
import Roll.Capability.MonadProduct (class MonadProduct)
import Roll.Capability.Slug (class MonadSlug, Slug)

type HTML m = H.ComponentHTML Action () m

data Action
    = SetWidth Int
    | SetHeight Int

type SizeWith a = { width :: Int, height :: Int | a }
type P1 = Array Category.Product
type P2 = Array ProductVariant.ProductVariant
type P3 = Maybe Slug
type SizeWithSystemWith a =
    { width :: Int
    , height :: Int
    , system :: P3
    | a
    }
type SizeWithSystemWithMaterialWith a =
    { width :: Int
    , height :: Int
    , system :: P3
    , material :: P3
    | a
    }
type AllData = SizeWithSystemWithMaterialWith (work :: P3)

data State
    = GetSize { width :: Maybe Int, height :: Maybe Int }
    | GetSystemP1 (SizeWith (system :: P1))
    | GetSystemP2 (SizeWith (system :: P2))
    | GetMaterialP1 (SizeWithSystemWith (material :: P1))
    | GetMaterialP2 (SizeWithSystemWith (material :: P2))
    | GetWorkP1 (SizeWithSystemWithMaterialWith (work :: P1))
    | GetWorkP2 (SizeWithSystemWithMaterialWith (work :: P2))
    | Calculate AllData

stateWidth :: Lens.Setter' State Int
stateWidth f = case _ of
    GetSize gs -> GetSize $ gs { width = Just <<< f <<< fromMaybe 0 $ gs.width }
    GetSystemP1 rec -> GetSystemP1 $ rec { width = f rec.width }
    GetSystemP2 rec -> GetSystemP2 $ rec { width = f rec.width }
    GetMaterialP1 rec -> GetMaterialP1 $ rec { width = f rec.width }
    GetMaterialP2 rec -> GetMaterialP2 $ rec { width = f rec.width }
    GetWorkP1 rec -> GetWorkP1 $ rec { width = f rec.width }
    GetWorkP2 rec -> GetWorkP2 $ rec { width = f rec.width }
    Calculate rec -> Calculate $ rec { width = f rec.width }

stateHeight :: Lens.Setter' State Int
stateHeight f = case _ of
    GetSize gs -> GetSize $ gs { height = Just <<< f <<< fromMaybe 0 $ gs.height }
    GetSystemP1 rec -> GetSystemP1 $ rec { height = f rec.width }
    GetSystemP2 rec -> GetSystemP2 $ rec { height = f rec.width }
    GetMaterialP1 rec -> GetMaterialP1 $ rec { height = f rec.width }
    GetMaterialP2 rec -> GetMaterialP2 $ rec { height = f rec.width }
    GetWorkP1 rec -> GetWorkP1 $ rec { height = f rec.width }
    GetWorkP2 rec -> GetWorkP2 $ rec { height = f rec.width }
    Calculate rec -> Calculate $ rec { height = f rec.width }

component
    :: forall q o m
     . MonadSlug m
    => MonadCategory m
    => MonadProduct m
    => H.Component HH.HTML q Unit o m
component =
    H.mkComponent
        { initialState: const $ GetSize { width: Nothing, height: Nothing }
        , render
        , eval: H.mkEval $ H.defaultEval
            { handleAction = handleAction
            }
        }

render :: forall m. State -> HTML m
render st =
    HH.section_
        [ HH.h1_
            [ HH.text "Configurator"
            ]
        , renderCurrentState st
        , renderOverall st
        ]

renderCurrentState :: forall m. State -> HTML m
renderCurrentState = case _ of
    GetSize _ -> renderWidthHeight
    _ -> HH.text "nope"

renderOverall :: forall m. State -> HTML m
renderOverall = case _ of
    GetSize { width, height } ->
        HH.div_
            [ HH.text $ "width: " <> show width
            , HH.text $ "height: " <> show height <> " | "
            ]
    _ -> HH.text "nop"


renderWidthHeight :: forall m. HTML m
renderWidthHeight =
    HH.div_
        [ renderNumericInput
            { id: "askWidth"
            , text: "Latime (cm):"
            , min: 100.0
            , max: 700.0
            , action: SetWidth
            }
        , renderNumericInput
            { id: "askHeight"
            , text: "Inaltime (cm):"
            , min: 100.0
            , max: 700.0
            , action: SetHeight
            }
        ]

renderNumericInput
    :: forall m
     . { id :: String, text :: String, min :: Number, max :: Number, action :: Int -> Action }
    -> HTML m
renderNumericInput {id, text, min, max, action} =
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
            , HE.onValueInput go
            ]
        ]
  where
    go :: String -> Maybe Action
    go = map (action <<< Int.ceil) <<< Number.fromString

handleAction
    :: forall m o
     . MonadSlug m
    => MonadCategory m
    => MonadProduct m
    => Action
    -> H.HalogenM State Action () o m Unit
handleAction = case _ of
    SetWidth i -> stateWidth .= i
    SetHeight i -> stateHeight .= i
