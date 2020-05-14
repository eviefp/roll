module Roll.API.Component.Hook.CategoryView
    ( CategoryView(..)
    , Step(..)
    , hook
    ) where

import Prelude

import Control.Monad.Except (runExceptT)
import DOM.HTML.Indexed as D
import Data.Either (hush)
import Data.Generic.Rep as G
import Data.Generic.Rep.Show as GS
import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype)
import Data.Tuple.Nested ((/\), type (/\))
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

type HTML m = H.ComponentHTML (Hooks.HookM m Unit) () m

type HookComponent m a = a /\ (Unit -> HTML m)

data Step = Minimized | ShowProducts | ShowVariants String

derive instance eqCategoryStep :: Eq Step
derive instance genericCategoryStep :: G.Generic Step _

instance showCategoryStep :: Show Step where
    show cs = GS.genericShow cs

newtype CategoryView hooks
    = CategoryView
        ( Hooks.UseEffect
        ( UseAPI.UseAPI (Array Category.Product)
        ( Hooks.UseState (Array String)
        ( Hooks.UseState (Maybe (Array (PV.ProductVariant)))
        ( Hooks.UseState Step
        ( Hooks.UseState (Maybe String) hooks ))))))

derive instance newtypeCategoryView :: Newtype (CategoryView hooks) _

type UpdateSlugs m = (Array String -> Hooks.HookM m Unit)

hook
    :: forall m
     . MonadAff m
    => String
    -> String
    -> Hooks.Hook
      m
      CategoryView
      (Maybe String /\ UpdateSlugs m /\ (Unit -> HTML m))
hook slug text = Hooks.wrap Hooks.do
    system /\ modifySystem <- Hooks.useState Nothing
    systemsStep /\ modifySystemsStep <- Hooks.useState Minimized
    systemShowVariants /\ modifySystemShowVariants <- Hooks.useState Nothing
    slugs /\ modifySlugs <- Hooks.useState []
    systems <- UseAPI.hook (Category.getRestrictedProducts slug) slugs

    Hooks.captures { systemsStep } Hooks.useTickEffect do
        case systemsStep of
            ShowVariants s -> do
                variants <- H.liftAff $ runExceptT $ PV.getProducts s
                modifySystemShowVariants (const (hush variants))
                pure Nothing
            _ -> pure Nothing

    let
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

        render :: Unit -> HTML m
        render _ =
            HH.section_
                [ HH.header
                    [ HE.onClick $ Just <<< const (modifySystemsStep (const ShowProducts))
                    ]
                    [ HH.text text
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
    Hooks.pure $ system /\ (modifySlugs <<< const) /\ render

