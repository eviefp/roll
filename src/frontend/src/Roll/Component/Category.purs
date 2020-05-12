module Roll.Component.Category
    ( component
    , renderProduct
    ) where

import Prelude

import Data.Maybe (Maybe(..), maybe)
import DOM.HTML.Indexed as D
import Effect.Aff.Class (class MonadAff)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Halogen.Hooks as Hooks
import Roll.API.Category as Category
import Roll.API.Component.Hook.UseAPI as UseAPI
import Roll.API.Component.Hook.UseSlug as UseSlug
import Roll.Component.Internal as I

type State =
    { title :: Maybe String
    , products :: Maybe (Array Category.Product)
    }

component :: forall q o m. MonadAff m => H.Component HH.HTML q Unit o m
component = Hooks.component \_ _ -> Hooks.do
    slug     <- UseSlug.hook
    title    <- maybe (I.hpure Nothing) (UseAPI.hook Category.getBySlug) slug
    products <- maybe (I.hpure Nothing) (UseAPI.hook Category.getProducts) slug
    Hooks.pure $ render { title, products }

render :: forall p i. State -> HH.HTML p i
render {title: Just t, products: Just p} =
    HH.section_
        [ HH.h1_
            [ HH.text t
            ]
        , HH.ul_
            $ renderProduct withUrl <$> p
        ]
render _ = I.loading

withUrl :: forall i. Category.Product -> Array (HH.IProp D.HTMLa i)
withUrl p =
    [ HP.href $ "/produs/" <> p.slug
    ]

renderProduct
    :: forall p i
     . (Category.Product -> Array (HH.IProp D.HTMLa i))
    -> Category.Product
    -> HH.HTML p i
renderProduct prop p =
    HH.li_
        [ HH.dt_
            [ HH.a
                (prop p)
                [ HH.img
                    [ HP.src "https://placeimg.com/250/150/architecture"
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

