module Roll.AppM
    ( AppM (..)
    , runAppM
    ) where

import Prelude

import Control.Monad.Except (runExceptT)
import Data.Either (hush)
import Effect.Aff (Aff)
import Effect.Aff.Class (class MonadAff)
import Effect.Class (class MonadEffect, liftEffect)
import Roll.API.Category as CategoryAPI
import Roll.API.ProductVariant as ProductVariantAPI
import Roll.Capability.Category (class MonadCategory, Title(Title))
import Roll.Capability.MonadProduct (class MonadProduct)
import Roll.Capability.Slug (class MonadSlug, Slug(Slug), unSlug)
import Roll.Component.Internal as I

newtype AppM a = AppM (Aff a)

runAppM :: AppM ~> Aff
runAppM (AppM aff) = aff

derive newtype instance functorAppM :: Functor AppM
derive newtype instance applyAppM :: Apply AppM
derive newtype instance applicativeAppM :: Applicative AppM
derive newtype instance bindAppM :: Bind AppM
derive newtype instance monadAppM :: Monad AppM
derive newtype instance monadEffectAppM :: MonadEffect AppM
derive newtype instance monadAffAppM :: MonadAff AppM

instance monadSlugAppM :: MonadSlug AppM where
    getSlug = liftEffect $ (map <<< map) Slug I.getSlug

instance monadCategoryAppM :: MonadCategory AppM where
    getTitle =
        AppM
            <<< map hush
            <<< runExceptT
            <<< map Title
            <<< CategoryAPI.getBySlug
            <<< unSlug
    getProducts =
        AppM
            <<< map hush
            <<< runExceptT
            <<< CategoryAPI.getProducts
            <<< unSlug

instance monadProductAppM :: MonadProduct AppM where
    getProducts =
        AppM
            <<< map hush
            <<< runExceptT
            <<< ProductVariantAPI.getProducts
            <<< unSlug
