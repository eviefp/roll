module Roll.Capability.Slug
    ( class MonadSlug
    , unSlug
    , getSlug
    , Slug (Slug)
    ) where

import Prelude

import Control.Monad.Cont.Trans (lift)
import Data.Maybe (Maybe)
import Halogen (HalogenM)


newtype Slug = Slug String

derive newtype instance showSlug :: Show Slug

unSlug :: Slug -> String
unSlug (Slug s) = s

class Monad m <= MonadSlug m where
    getSlug :: m (Maybe Slug)

instance monadSlugHalogenM :: MonadSlug m => MonadSlug (HalogenM st act slots msg m) where
    getSlug = lift getSlug
