module Roll.Calculator.Expr
    ( Identifier(..)
    , ExprF(..)
    , Expr
    , Statement(..)
    ) where

import           Roll.Prelude

import qualified Data.Functor.Classes  as Classes
import qualified Data.Functor.Foldable as F
import qualified Generic.Data          as G

newtype Identifier =
    Identifier
    { getIdentifier
          :: Text
    }
    deriving stock ( Generic, Show )
    deriving newtype ( Ord, Eq )

data ExprF a b where
    -- Variables and constants.
    Var
        :: Identifier -> ExprF a b
    Const
        :: a -> ExprF a b
    -- Arithmetic operators.
    Add
        :: b -> b -> ExprF a b
    Substract
        :: b -> b -> ExprF a b
    Multiply
        :: b -> b -> ExprF a b
    Divide
        :: b -> b -> ExprF a b
    -- -- Rounding
    Floor
        :: b -> ExprF a b
    Ceil
        :: b -> ExprF a b
    Round
        :: b -> ExprF a b
    -- -- Comparison
    Min
        :: b -> b -> ExprF a b
    Max
        :: b -> b -> ExprF a b
    deriving stock ( Functor, Generic, Generic1, Show )

instance (Show a) => Classes.Show1 (ExprF a) where
    liftShowsPrec a b = G.gliftShowsPrec a b

data Statement where
    In
        :: Identifier -> Statement
    Assign
        :: Identifier -> Expr Double -> Statement
    Out
        :: Identifier -> Statement
    deriving stock ( Generic, Show )

type Expr a = F.Fix (ExprF a)
