module Roll.Component.Category
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
import Roll.API.Category as Category
import Roll.Component.Internal as I

type HTML m = H.ComponentHTML Action () m

data Action = Initialize

type State =
    { title :: Maybe String
    , products :: Maybe (Array Category.Product)
    }

component :: forall q o m. MonadAff m => H.Component HH.HTML q Unit o m
component =
    H.mkComponent
    { initialState: const { title: Nothing, products: Nothing }
    , render
    , eval: H.mkEval H.defaultEval
        { handleAction = handleAction
        , initialize = Just Initialize
        }
    }

render :: forall m. State -> HTML m
render {title: Just t, products: Just p} =
    HH.div_
        [ HH.text t
        , HH.div_ $ renderProduct <$> p
        ]
render _ = HH.text "loading..."

renderProduct :: forall m. Category.Product -> HTML m
renderProduct { slug, name, price, description } =
    HH.div_
        [ HH.a
            [ HP.href $ "/produs/" <> slug
            ]
            [ HH.text name
            , HH.text $ "de la " <> show price
            ]
        , HH.p_
            [ I.maybeElement description HH.text
            ]
        ]

handleAction :: forall m o. MonadAff m => Action -> H.HalogenM State Action () o m Unit
handleAction = case _ of
    Initialize ->
        ( H.liftAff $ runExceptT do
            slug <- I.getSlug
            title <- Category.getBySlug slug
            products <- Category.getProducts slug
            pure { products: Just products, title: Just title }
        )
        >>= case _ of
            Left _ -> mempty
            Right st -> H.put st

