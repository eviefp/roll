module Roll.Calculator.Parser
    ( parseExpr
    , parseStatement
    , parseProgram
    , Parser
    ) where

import Roll.Prelude

import qualified Roll.Calculator.Expr as E

import qualified Data.Fix                   as F
import qualified Data.Text                  as T
import qualified Text.Megaparsec            as M
import qualified Text.Megaparsec.Char       as MC
import qualified Text.Megaparsec.Char.Lexer as ML

type Parser = M.Parsec Void Text

type Expr = E.Expr Double

type ExprF = E.ExprF Double Expr

parseProgram
    :: Parser [ E.Statement ]
parseProgram = M.many end *> M.many (parseStatement <* end)

parseStatement
    :: Parser E.Statement
parseStatement =
    M.try (E.In <$> (lexeme "in" *> parseIdentifier) <*> parseDouble)
    <|> M.try (parseUnaryId "out" E.Out)
    <|> parseAssignment

parseUnaryId
    :: Text -> (E.Identifier -> E.Statement) -> Parser E.Statement
parseUnaryId instr ctor =
    do
        _ <- lexeme (MC.string instr)
        ctor <$> parseIdentifier

parseAssignment
    :: Parser E.Statement
parseAssignment =
    do
        ident <- parseIdentifier
        _ <- lexeme (MC.string "=")
        expr <- parseExpr
        pure (E.Assign ident expr)

parseExpr
    :: Parser Expr
parseExpr =
    asum
        (fmap
             M.try
             [ parseOp '+' E.Add
             , parseOp '-' E.Substract
             , parseOp '*' E.Multiply
             , parseOp '/' E.Divide
             , parseUnaryFn "floor" E.Floor
             , parseUnaryFn "ceil" E.Ceil
             , parseUnaryFn "round" E.Round
             , parseBinaryFn "min" E.Min
             , parseBinaryFn "max" E.Max
             ])
    <|> parseTerm

parseTerm
    :: Parser Expr
parseTerm =
    parseConst <|> parseVar <|> M.between (symbol "(") (symbol ")") parseExpr

parseVar
    :: Parser Expr
parseVar = F.Fix . E.Var <$> lexeme parseIdentifier

parseConst
    :: Parser Expr
parseConst = F.Fix . E.Const <$> lexeme parseDouble

parseOp
    :: Char -> (Expr -> Expr -> ExprF) -> Parser Expr
parseOp op ctor =
    do
        left <- parseTerm
        _ <- lexeme (MC.char op)
        right <- parseTerm
        pure (F.Fix (ctor left right))

parseUnaryFn
    :: Text -> (Expr -> ExprF) -> Parser Expr
parseUnaryFn fn ctor =
    do
        _ <- lexeme (MC.string fn)
        F.Fix . ctor <$> parseTerm

parseBinaryFn
    :: Text -> (Expr -> Expr -> ExprF) -> Parser Expr
parseBinaryFn fn ctor =
    do
        _ <- lexeme (MC.string fn)
        (F.Fix .) . ctor <$> parseTerm <*> parseTerm

space
    :: Parser ()
space = ML.space (M.some (MC.char ' ') $> ()) M.empty M.empty

lexeme
    :: Parser a -> Parser a
lexeme = ML.lexeme space

symbol
    :: Text -> Parser Text
symbol = ML.symbol space

parseIdentifier
    :: Parser E.Identifier
parseIdentifier = E.Identifier . T.pack <$> lexeme (M.some MC.alphaNumChar)

parseDouble
    :: Parser Double
parseDouble = ML.signed mempty (M.try ML.float <|> ML.decimal)

end
    :: Parser ()
end = (M.some (lexeme MC.eol) $> ()) <|> (symbol ";" $> ()) <|> M.eof

