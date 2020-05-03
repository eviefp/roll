module Roll.Component.Hello
    ( component
    ) where

import Prelude

import Control.Monad.Except (runExceptT)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Effect.Aff.Class (class MonadAff)
import Effect.Random as R
import Halogen as H
import Halogen.HTML as HH
import Roll.API.Quote as Quote

type HTML m = H.ComponentHTML Action () m

data Action = Initialize

type State = String

component :: forall q o m. MonadAff m => H.Component HH.HTML q Unit o m
component =
    H.mkComponent
    { initialState: const "loading quote..."
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
        (H.liftEffect $ R.randomInt 0 100)
            >>= (H.liftAff <<< runExceptT <<< Quote.get)
            >>= case _ of
                Left err -> pure "Could not load quote."
                Right q  -> pure q
            >>= H.put
