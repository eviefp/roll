module Roll.Component.Configurator
    ( component
    ) where

import Prelude

import Data.Maybe (Maybe(..), maybe)
import Effect.Aff.Class (class MonadAff)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Halogen.Hooks as Hooks
import Roll.API.Component.Hook.UseAPI as UseAPI
import Roll.API.Component.Hook.UseSlug as UseSlug
import Roll.API.ProductVariant as ProductVariant
import Roll.Component.Internal as I

type State =
    { products :: Maybe (Array ProductVariant.ProductVariant)
    }

component :: forall q o m. MonadAff m => H.Component HH.HTML q Unit o m
component = Hooks.component \_ _ -> Hooks.do
    slug <- UseSlug.hook
    products <-
        maybe
            (I.hpure Nothing)
            (UseAPI.hook ProductVariant.getProducts)
            slug
    Hooks.pure $ render { products }

render :: forall p i. State -> HH.HTML p i
render { products: Just p } =
        HH.ul_ $ renderProduct <$> p
render _ = I.loading

renderProduct :: forall p i. ProductVariant.ProductVariant -> HH.HTML p i
renderProduct p =
    HH.li_
        [ HH.dt_
            [ HH.a
                [ HP.href $ "/configurator/" <> p.slug
                ]
                [ HH.img
                    [ HP.src "https://placeimg.com/250/150/animals"
                    ]
                , HH.h3_
                    [ HH.text p.name
                    ]
                , HH.samp_
                    [ HH.text $ show p.price
                    ]
                ]
            ]
        , HH.dd_
            [ I.maybeElement p.description HH.text
            ]
        ]

