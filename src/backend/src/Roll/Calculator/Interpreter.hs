module Roll.Calculator.Interpreter
    ( evalExpr
    , eval
    ) where

import           Roll.Prelude

import           Roll.Calculator.Expr       as E

import qualified Control.Monad.State.Strict as S
import qualified Data.Functor.Foldable      as F
import qualified Data.Map                   as M

eval
    :: [ E.Statement ] -> M.Map Identifier Double -> (M.Map Identifier Double)
eval stmts inputs =
    (`S.evalState` inputs)
    $ do
        res <- traverse evalStatement stmts
        pure
            $ foldl1 M.union res

evalStatement
    :: E.Statement
    -> S.State (M.Map Identifier Double) (M.Map E.Identifier Double)
evalStatement =
    \case
        -- TODO: Currently everything that was 'out'putted will be available
        -- 'in' the current scope. We should probably tag variables somehow
        -- if we want to enforce this.
        E.In _              -> pure mempty
        E.Out ident         -> maybe mempty (M.singleton ident)
            <$> S.gets (M.lookup ident)
        E.Assign ident expr -> S.modify (go ident expr) $> M.empty
  where
    go
        :: E.Identifier
        -> E.Expr Double
        -> M.Map E.Identifier Double
        -> M.Map E.Identifier Double
    go ident expr vars =
        M.alter
            (const
             $ evalExpr vars expr)
            ident
            vars

evalExpr
    :: M.Map Identifier Double -> E.Expr Double -> Maybe Double
evalExpr vars = F.cata go
  where
    go
        :: E.ExprF Double (Maybe Double) -> Maybe Double
    go =
        \case
            Var ident            -> ident `M.lookup` vars
            Const val            -> pure val
            Add left right       -> (+) <$> left <*> right
            Substract left right -> (-) <$> left <*> right
            Multiply left right  -> (*) <$> left <*> right
            Divide left right    -> (/) <$> left <*> right
            Floor val            -> fromInteger . floor <$> val
            Ceil val             -> fromInteger . ceiling <$> val
            Round val            -> fromInteger . round <$> val
            Min left right       -> min <$> left <*> right
            Max left right       -> max <$> left <*> right


