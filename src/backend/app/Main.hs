module Main
    ( main
    ) where

import           Roll.Prelude

import           Roll
    ( startApp
    )

main
    :: IO ()
main =
    putStrLn "Starting Roll..."
    *> startApp
