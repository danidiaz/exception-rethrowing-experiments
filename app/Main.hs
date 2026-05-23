{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE ImplicitParams #-}
module Main (main) where

import Control.Exception
import PrettyException (catchAndPrintSomeException)
import Control.Exception.Backtrace (setBacktraceMechanismState, BacktraceMechanism (IPEBacktrace, HasCallStackBacktrace))
import GHC.Stack (HasCallStack)

catchAndThrow :: IO a -> IO a
catchAndThrow action = catch action \(e :: SomeException) -> throwIO e

catchAndRethrow :: IO a -> IO a
catchAndRethrow action = catchNoPropagate @(ExceptionWithContext SomeException) action rethrowIO

foo :: HasCallStack => IO ()
foo = do
  bar 

bar :: HasCallStack => IO  ()
bar = throwIO (userError "urk")

main :: IO ()
main = do
  setBacktraceMechanismState IPEBacktrace True
  setBacktraceMechanismState HasCallStackBacktrace True
  putStrLn "# catchAndThrow \n"
  catchAndPrintSomeException (catchAndThrow foo)
  putStrLn "\n"
  putStrLn "# catchAndRethrow \n"
  catchAndPrintSomeException (catchAndRethrow foo)
