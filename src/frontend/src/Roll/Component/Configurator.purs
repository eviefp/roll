module Roll.Component.Configurator
    ( component
    ) where

import Prelude

import Control.Monad.Except (runExceptT)
import DOM.HTML.Indexed as D
import Data.Either (hush)
import Data.Generic.Rep as G
import Data.Generic.Rep.Show as GS
import Data.Int as Int
import Data.Maybe (Maybe(..))
import Data.Number as Number
import Data.Tuple.Nested ((/\))
import Effect.Aff.Class (class MonadAff)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Halogen.Hooks as Hooks
import Roll.API.Category as Category
import Roll.API.Component.Hook.UseAPI as UseAPI
import Roll.API.ProductVariant as PV
import Roll.Component.Category as CC
import Roll.Component.Internal as I
import Roll.Component.Product as CP

data Step = Minimized | ShowProducts | ShowVariants String

derive instance eqCategoryStep :: Eq Step
derive instance genericCategoryStep :: G.Generic Step _

instance showCategoryStep :: Show Step where
    show cs = GS.genericShow cs

component :: forall q o m. MonadAff m => H.Component HH.HTML q Unit o m
component = Hooks.component \_ _ -> Hooks.do
    width /\ modifyWidth <- Hooks.useState Nothing
    height /\ modifyHeight <- Hooks.useState Nothing
    system /\ modifySystem <- Hooks.useState Nothing
    systemsStep /\ modifySystemsStep <- Hooks.useState Minimized
    systemShowVariants /\ modifySystemShowVariants <- Hooks.useState Nothing

    systems <- UseAPI.hook Category.getProducts "sisteme"

    Hooks.captures { systemsStep } Hooks.useTickEffect do
        case systemsStep of
            ShowVariants slug -> do
                variants <- H.liftAff $ runExceptT $ PV.getProducts slug
                modifySystemShowVariants (const (hush variants))
                pure Nothing
            _ -> pure Nothing


    let
        updateFn
            :: ((Maybe Int -> Maybe Int) -> Hooks.HookM m Unit)
            -> String
            -> Hooks.HookM m Unit
        updateFn modify = modify <<< const <<< map Int.ceil <<< Number.fromString

        renderWidthHeight :: forall p. Array (HH.HTML p (Hooks.HookM m Unit))
        renderWidthHeight =
            [ HH.fieldset_
                [ HH.label
                    [ HP.for "askWidth"
                    ]
                    [ HH.text "Latime (cm): "
                    ]
                , HH.input
                    [ HP.type_ HP.InputNumber
                    , HP.min 100.0
                    , HP.max 700.0
                    , HP.id_ "askWidth"
                    , HE.onValueInput (Just <<< updateFn modifyWidth)
                    ]
                ]
            , HH.fieldset_
                [ HH.label
                    [ HP.for "askHeight"
                    ]
                    [ HH.text "Inaltime (cm): "
                    ]
                , HH.input
                    [ HP.type_ HP.InputNumber
                    , HP.min 100.0
                    , HP.max 700.0
                    , HP.id_ "askWidth"
                    , HE.onValueInput (Just <<< updateFn modifyHeight)
                    ]
                ]
            ]

        withSelectProduct
            :: Category.Product
            -> Array (HH.IProp D.HTMLa (Hooks.HookM m Unit))
        withSelectProduct p =
            [ HP.href "#"
            , HE.onClick $ Just <<< const (modifySystemsStep (const (ShowVariants p.slug)))
            ]

        withSelectPV
            :: PV.ProductVariant
            -> Array (HH.IProp D.HTMLa (Hooks.HookM m Unit))
        withSelectPV p =
            [ HP.href "#"
            , HE.onClick $ Just <<< const do
                modifySystemsStep (const Minimized)
                modifySystem (const (Just p.slug))
            ]

        renderSystem :: forall p. Array (HH.HTML p (Hooks.HookM m Unit))
        renderSystem =
            [ HH.header
                [ HE.onClick $ Just <<< const (modifySystemsStep (const ShowProducts))
                ]
                [ HH.text "Sistem"
                ]
            , case systemsStep of
                Minimized -> I.emptyElement
                ShowProducts ->
                    I.maybeElement systems do
                        HH.section_ <<< map (CC.renderProduct withSelectProduct)
                ShowVariants s ->
                    I.maybeElement systemShowVariants do
                       HH.section_ <<< map (CP.renderProductVariant withSelectPV)
            ]

        renderDebug :: forall p. Array (HH.HTML p (Hooks.HookM m Unit))
        renderDebug =
            [ HH.text $ show { width, height, systemsStep, system }
            ]

        render :: forall p. HH.HTML p (Hooks.HookM m Unit)
        render =
            HH.div_
                [ HH.section_ renderWidthHeight
                , HH.section_ renderSystem
                , HH.section_ renderDebug
                ]

    Hooks.pure render

