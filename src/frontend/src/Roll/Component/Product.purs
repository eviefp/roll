module Roll.Component.Product
    ( component
    ) where

import Prelude

import Control.Monad.Except (runExceptT)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Effect.Aff.Class (class MonadAff)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Roll.API.ProductVariant as ProductVariant
import Roll.Component.Internal as I

type HTML m = H.ComponentHTML Action () m

data Action = Initialize

type State =
    { products :: Maybe (Array ProductVariant.ProductVariant)
    }

component :: forall q o m. MonadAff m => H.Component HH.HTML q Unit o m
component =
    H.mkComponent
    { initialState: const { products: Nothing }
    , render
    , eval: H.mkEval H.defaultEval
        { handleAction = handleAction
        , initialize = Just Initialize
        }
    }

render :: forall m. State -> HTML m
render { products: Just p } =
        HH.ul_ $ renderProduct <$> p
render _ = I.loading

renderProduct :: forall m. ProductVariant.ProductVariant -> HTML m
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

handleAction :: forall m o. MonadAff m => Action -> H.HalogenM State Action () o m Unit
handleAction = case _ of
    Initialize ->
        ( H.liftAff <<< runExceptT $ I.getSlug >>= ProductVariant.getProducts)
        >>= case _ of
            Left _ -> mempty
            Right st -> H.put { products: Just st }

