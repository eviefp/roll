module Roll.NewComponents.Product
    ( component
    ) where

import Prelude

import DOM.HTML.Indexed as D
import Data.Maybe (Maybe(..), fromMaybe, maybe)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Record.Extra (sequenceRecord)
import Roll.API.ProductVariant as ProductVariant
import Roll.Capability.MonadProduct (class MonadProduct, getProducts)
import Roll.Capability.Slug (class MonadSlug, Slug(..), getSlug)
import Roll.Component.Internal as I
import Roll.NewComponents.Common as Common

type HTML m = H.ComponentHTML Action () m

data Action = Initialise

type State =
    { products :: Maybe (Array ProductVariant.ProductVariant)
    }

component
    :: forall q o m
     . MonadSlug m
    => MonadProduct m
    => H.Component HH.HTML q Unit o m
component =
    H.mkComponent
        { initialState: const { products: Nothing }
        , render: maybe I.loading render <<< sequenceRecord
        , eval: H.mkEval $ H.defaultEval
            { handleAction = handleAction
            , initialize = Just Initialise
            }
        }

render :: forall m. {  products :: Array ProductVariant.ProductVariant } -> HTML m
render  { products } =
    HH.section_
        [ HH.ul_ (Common.renderProductVariant withUrl <$> products)
        ]

withUrl :: forall i. ProductVariant.ProductVariant -> Array (HH.IProp D.HTMLa i)
withUrl p =
    [ HP.href $ "/configurator/" <> p.slug
    ]

handleAction
    :: forall m o
     . MonadSlug m
    => MonadProduct m
    => Action
    -> H.HalogenM State Action () o m Unit
handleAction = case _ of
    Initialise -> do
       slug <- fromMaybe (Slug "sisteme") <$> getSlug
       products <- getProducts slug
       H.put { products }

