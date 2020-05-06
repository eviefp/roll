module Roll.Component.Category
    ( component
    ) where

import Prelude

import Control.Monad.Except (ExceptT(..), runExceptT)
import Data.Array (foldMap)
import Data.Either (Either(..), note)
import Data.Maybe (Maybe(..))
import Data.Maybe.Last as Maybe
import Data.Newtype (unwrap)
import Data.String as S
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Aff.Class (class MonadAff)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Roll.API.Category as Category
import Roll.API.Internal (Error(..))
import Roll.Component.Internal as I
import Web.HTML as HTML
import Web.HTML.Location as Location
import Web.HTML.Window as Window

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
renderProduct { slug, name, description } =
    HH.div_
        [ HH.a
            [ HP.href $ "/produs/" <> slug
            ]
            [ HH.text name
            ]
        , HH.p_
            [ I.maybeElement description HH.text
            ]
        ]

handleAction :: forall m o. MonadAff m => Action -> H.HalogenM State Action () o m Unit
handleAction = case _ of
    Initialize ->
        ( H.liftAff $ runExceptT do
            slug <- getSlug
            title <- Category.getBySlug slug
            products <- Category.getProducts slug
            pure { products: Just products, title: Just title }
        )
        >>= case _ of
            Left _ -> mempty
            Right st -> H.put st

getSlug :: ExceptT Error Aff String
getSlug = ExceptT $ note UnknownError <<< go <$> H.liftEffect href
  where
    go :: String -> Maybe String
    go = unwrap <<< foldMap (Maybe.Last <<< Just) <<< S.split (S.Pattern "/")

href :: Effect String
href = HTML.window >>= Window.location >>= Location.href


