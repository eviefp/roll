module Roll.NewComponents.Configurator
    ( component
    ) where

import Prelude

import DOM.HTML.Indexed as D
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Int as Int
import Data.Lens ((.=))
import Data.Lens as Lens
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Number as Number
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Roll.API.Category as Cat
import Roll.API.ProductVariant as ProductVariant
import Roll.Capability.Category as Category
import Roll.Capability.MonadProduct as Product
import Roll.Capability.Slug (class MonadSlug, Slug(..))
import Roll.NewComponents.Common as Common

type HTML m = H.ComponentHTML Action () m

data Action
    = SetWidth Int
    | SetHeight Int
    | WidthHeightDone
    | SelectSystemP1 Slug
    | SelectSystemP2 Slug
    | SelectMaterialP1 Slug
    | SelectMaterialP2 Slug

type P1 = Array Cat.Product
type P2 = Array ProductVariant.ProductVariant
type P3 = Maybe Slug

type SizeWith a =
    { width :: Int
    , height :: Int
    | a
    }
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
type AllData = SizeWithSystemWithMaterialWith
    ( work :: P3
    )

data State
    = GetSize { width :: Maybe Int, height :: Maybe Int }
    | GetSystemP1 (SizeWith (system :: P1))
    | GetSystemP2 (SizeWith (system :: P2))
    | GetMaterialP1 (SizeWithSystemWith (material :: P1))
    | GetMaterialP2 (SizeWithSystemWith (material :: P2))
    | GetWorkP1 (SizeWithSystemWithMaterialWith (work :: P1))
    | GetWorkP2 (SizeWithSystemWithMaterialWith (work :: P2))
    | Calculate AllData

derive instance genericState :: Generic State _

instance showState :: Show State where
    show s = genericShow s

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

gotoSystemP1
    :: forall o m
     . Category.MonadCategory m
    => H.HalogenM State Action () o m Unit
gotoSystemP1 = do
    msystem <- Category.getProducts $ Slug "sisteme"
    H.modify_
        case _ of
            GetSize gs ->
                fromMaybe (GetSize gs) do
                    width <- gs.width
                    height <- gs.height
                    system <- msystem
                    pure $ GetSystemP1 { width, height, system }
            other -> other

gotoSystemP2
    :: forall o m
     . Product.MonadProduct m
    => Slug
    -> H.HalogenM State Action () o m Unit
gotoSystemP2 s = do
    Product.getProducts s >>= case _ of
        Nothing -> pure unit
        Just pv ->
            H.modify_
                case _ of
                    GetSystemP1 { width, height } ->
                        GetSystemP2 { width, height, system: pv }
                    other -> other

gotoMaterialP1
    :: forall o m
     . Category.MonadCategory m
    => Slug
    -> H.HalogenM State Action () o m Unit
gotoMaterialP1 slug = do
    Category.getRestrictedProducts (Slug "materiale") [ slug ] >>= case _ of
        Nothing -> pure unit
        Just mats ->
            H.modify_
                case _ of
                    GetSystemP2 { width, height } ->
                        GetMaterialP1 { width, height, system: Just slug, material: mats }
                    other -> other

gotoMaterialP2
    :: forall o m
     . Product.MonadProduct m
    => Slug
    -> H.HalogenM State Action () o m Unit
gotoMaterialP2 s = do
    Product.getProducts s >>= case _ of
        Nothing -> pure unit
        Just pv ->
            H.modify_
                case _ of
                    GetMaterialP1 { width, height, system } ->
                        GetMaterialP2 { width, height, system, material: pv }
                    other -> other

gotoWorkP1
    :: forall o m
     . Category.MonadCategory m
    => Slug
    -> H.HalogenM State Action () o m Unit
gotoWorkP1 slug = do
    -- we need both slugs here!
    Category.getRestrictedProducts (Slug "manopera") [slug] >>= case _ of
        Nothing -> pure unit
        Just work ->
            H.modify_
                case _ of
                    GetMaterialP2 { width, height, system } ->
                        GetWorkP1 { width, height, system: system, material: Just slug, work }
                    other -> other

component
    :: forall q o m
     . MonadSlug m
    => Category.MonadCategory m
    => Product.MonadProduct m
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
    GetSize s -> renderWidthHeight s
    GetSystemP1 p -> renderProducts SelectSystemP1 p.system
    GetSystemP2 p -> renderProductVariants SelectSystemP2 p.system
    GetMaterialP1 p -> renderProducts SelectMaterialP1 p.material
    GetMaterialP2 p -> renderProductVariants SelectMaterialP2 p.material
    _ -> HH.text "nope"

renderOverall :: forall m. State -> HTML m
renderOverall state =
        HH.div_ [ HH.text $ show state ]

renderWidthHeight :: forall m. { width :: Maybe Int, height :: Maybe Int } -> HTML m
renderWidthHeight s =
    HH.div_ $
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
        ] <> renderNextButton s

renderProducts :: forall m. (Slug -> Action) -> P1 -> HTML m
renderProducts ctor arr =
    HH.div_ $ Common.renderProduct withUrl <$> arr
  where
    withUrl :: Cat.Product -> Array (HH.IProp D.HTMLa Action)
    withUrl p =
        [ HP.href "#"
        , HE.onClick $ Just <<< const (ctor $ Slug p.slug)
        ]

renderProductVariants :: forall m. (Slug -> Action) -> P2 -> HTML m
renderProductVariants ctor arr =
    HH.div_ $ Common.renderProductVariant withUrl <$> arr
  where
    withUrl :: ProductVariant.ProductVariant -> Array (HH.IProp D.HTMLa Action)
    withUrl p =
        [ HP.href "#"
        , HE.onClick $ Just <<< const (ctor $ Slug p.slug)
        ]

renderNextButton
    :: forall m
     . { width :: Maybe Int, height :: Maybe Int }
    -> Array (HTML m)
renderNextButton s =
    case s.width, s.height of
        Just _, Just _ -> [ renderButton { action: WidthHeightDone, text: "Next" } ]
        _, _           -> []

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

renderButton
    :: forall m
     . { text :: String, action :: Action }
    -> HTML m
renderButton { text, action } =
    HH.a
        [ HP.href "#"
        , HE.onClick $ Just <<< const action
        ]
        [ HH.text text
        ]

handleAction
    :: forall m o
     . MonadSlug m
    => Category.MonadCategory m
    => Product.MonadProduct m
    => Action
    -> H.HalogenM State Action () o m Unit
handleAction = case _ of
    SetWidth i            -> stateWidth .= i
    SetHeight i           -> stateHeight .= i
    WidthHeightDone       -> gotoSystemP1
    SelectSystemP1 slug   -> gotoSystemP2 slug
    SelectSystemP2 slug   -> gotoMaterialP1 slug
    SelectMaterialP1 slug -> gotoMaterialP2 slug
    SelectMaterialP2 slug -> gotoWorkP1 slug
