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
import Roll.API.Category as Category
import Roll.API.Internal (Error(..))
import Web.HTML as HTML
import Web.HTML.Location as Location
import Web.HTML.Window as Window

type HTML m = H.ComponentHTML Action () m

data Action = Initialize

type State = String

component :: forall q o m. MonadAff m => H.Component HH.HTML q Unit o m
component =
    H.mkComponent
    { initialState: const "loading category..."
    , render
    , eval: H.mkEval H.defaultEval
        { handleAction = handleAction
        , initialize = Just Initialize
        }
    }

render :: forall m. State -> HTML m
render = HH.text

handleAction :: forall m o. MonadAff m => Action -> H.HalogenM State Action () o m Unit
handleAction = case _ of
    Initialize ->
        (H.liftAff <<< runExceptT $ getSlug >>= Category.getBySlug)
            >>= case _ of
                Left err -> pure "Could not load slug."
                Right q  -> pure q
            >>= H.put

getSlug :: ExceptT Error Aff String
getSlug = ExceptT $ note UnknownError <<< go <$> H.liftEffect href
  where
    go :: String -> Maybe String
    go = unwrap <<< foldMap (Maybe.Last <<< Just) <<< S.split (S.Pattern "/")

href :: Effect String
href = HTML.window >>= Window.location >>= Location.href


