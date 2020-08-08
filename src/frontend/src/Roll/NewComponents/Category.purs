module Roll.NewComponents.Category
    ( component
    ) where

import Prelude

import DOM.HTML.Indexed as D
import Data.Maybe (Maybe(..), fromMaybe, maybe)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Record.Extra (sequenceRecord)
import Roll.API.Category as Category
import Roll.Capability.Category (class MonadCategory, Title, getProducts, getTitle, unTitle)
import Roll.Capability.Slug (class MonadSlug, Slug(..), getSlug)
import Roll.Component.Internal as I

type HTML m = H.ComponentHTML Action () m

data Action = Initialise

type State =
    { title :: Maybe Title
    , products :: Maybe (Array Category.Product)
    }

component
    :: forall q o m
     . MonadSlug m
    => MonadCategory m
    => H.Component HH.HTML q Unit o m
component =
    H.mkComponent
        { initialState: const { title: Nothing, products: Nothing }
        , render: maybe I.loading render <<< sequenceRecord
        , eval: H.mkEval $ H.defaultEval
            { handleAction = handleAction
            , initialize = Just Initialise
            }
        }

render :: forall m. { title :: Title, products :: Array Category.Product } -> HTML m
render  { title, products } =
    HH.section_
        [ HH.h1_
            [ HH.text (unTitle title)
            ]
        , HH.ul_ (renderProduct withUrl <$> products)
        ]

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

handleAction
    :: forall m o
     . MonadSlug m
    => MonadCategory m
    => Action
    -> H.HalogenM State Action () o m Unit
handleAction = case _ of
    Initialise -> do
       slug <- fromMaybe (Slug "sisteme") <$> getSlug
       title <- getTitle slug
       products <- getProducts slug
       H.put { title, products }

