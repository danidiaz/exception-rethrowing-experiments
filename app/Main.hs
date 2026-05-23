module Main (main) where

import qualified PrettyException (someFunc)

main :: IO ()
main = do
  putStrLn "Hello, Haskell!"
  PrettyException.someFunc
