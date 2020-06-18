module Roll.Component.Product
    ( component
    , renderProductVariant
    ) where

import Prelude

import Control.Monad.Except.Trans (ExceptT)
import Control.Monad.Except.Trans as Except
import DOM.HTML.Indexed as D
import Data.Maybe (Maybe(..), maybe)
import Effect.Aff (Aff)
import Effect.Aff.Class (class MonadAff)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Halogen.Hooks as Hooks
import Roll.API.Component.Hook.UseAPI as UseAPI
import Roll.API.Component.Hook.UseSlug as UseSlug
import Roll.API.Internal as AI
import Roll.API.ProductVariant as ProductVariant
import Roll.Component.Internal as I

type State =
    { products :: Maybe (Array ProductVariant.ProductVariant)
    }

component :: forall q o m. MonadAff m => H.Component HH.HTML q Unit o m
component = Hooks.component \_ _ -> Hooks.do
    slug <- UseSlug.hook
    products <- UseAPI.hook (applyMaybe ProductVariant.getProducts) slug
    Hooks.pure $ render { products }
  where
    applyMaybe
        :: forall a
         . (String -> ExceptT AI.Error Aff a)
        -> Maybe String
        -> ExceptT AI.Error Aff a
    applyMaybe f slug =
        maybe (Except.throwError AI.UnknownError) f slug

render :: forall p i. State -> HH.HTML p i
render { products: Just p } =
        HH.ul_ $ renderProductVariant withUrl <$> p
render _ = I.loading

withUrl :: forall i. ProductVariant.ProductVariant -> Array (HH.IProp D.HTMLa i)
withUrl p =
    [ HP.href $ "/configurator/" <> p.slug
    ]

renderProductVariant
    :: forall p i
     . (ProductVariant.ProductVariant -> Array (HH.IProp D.HTMLa i))
    -> ProductVariant.ProductVariant
    -> HH.HTML p i
renderProductVariant prop p =
    HH.li_
        [ HH.dt_
            [ HH.a
                (prop p)
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

