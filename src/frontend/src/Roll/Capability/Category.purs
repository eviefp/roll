module Roll.Capability.Category
    ( class MonadCategory
    , getTitle
    , getProducts
    , unTitle
    , Title (Title)
    ) where

import Prelude

import Control.Monad.Cont.Trans (lift)
import Data.Maybe (Maybe)
import Halogen (HalogenM)
import Roll.API.Category (Product)
import Roll.Capability.Slug (Slug)


newtype Title = Title String

unTitle :: Title -> String
unTitle (Title s) = s


class Monad m <= MonadCategory m where
    getTitle :: Slug -> m (Maybe Title)
    getProducts :: Slug -> m (Maybe (Array Product))

instance monadCategoryHalogenM :: MonadCategory m => MonadCategory (HalogenM st act slots msg m) where
    getTitle = lift <<< getTitle
    getProducts = lift <<< getProducts
