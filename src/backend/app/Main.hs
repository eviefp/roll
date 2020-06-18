module Main
    ( main
    ) where

import           Roll.Prelude

import           Roll
    ( startApp
    )

import           System.Environment
    ( getArgs
    )

main
    :: IO ()
main =
    do
        putStrLn "Starting Roll..."
        getArgs
            >>= startApp . fromMaybe "roll.yaml" . listToMaybe
