module Roll.Capability.MonadProduct
    ( class MonadProduct
    , getProducts
    ) where

import Prelude

import Control.Monad.Cont.Trans (lift)
import Data.Maybe (Maybe)
import Halogen (HalogenM)
import Roll.API.ProductVariant as PV
import Roll.Capability.Slug (Slug)

class Monad m <= MonadProduct m where
    getProducts :: Slug -> m (Maybe (Array PV.ProductVariant))

instance monadCategoryHalogenM :: MonadProduct m => MonadProduct (HalogenM st act slots msg m) where
    getProducts = lift <<< getProducts
