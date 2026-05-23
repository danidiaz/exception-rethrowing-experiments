{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE ImplicitParams #-}
module Main (main) where

import Control.Exception
import PrettyException (catchAndPrintSomeException)
import Control.Exception.Backtrace (setBacktraceMechanismState, 
            BacktraceMechanism (
              -- IPEBacktrace, 
              HasCallStackBacktrace)
            )
import GHC.Stack (HasCallStack)

catchAndThrow :: IO a -> IO a
catchAndThrow action = catch action \(e :: SomeException) -> throwIO e

-- like 'catchAndThrow', but with a type of exception for which 'toException' 
-- preserves context
catchAndThrow' :: IO a -> IO a
catchAndThrow' action = catch action \(e :: ExceptionWithContext SomeException) -> throwIO e

catchAndRethrow :: IO a -> IO a
catchAndRethrow action = catchNoPropagate @(ExceptionWithContext SomeException) action rethrowIO

foo :: HasCallStack => IO ()
foo = do
  bar 

bar :: HasCallStack => IO  ()
bar = throwIO (userError "urk")

main :: IO ()
main = do
  -- setBacktraceMechanismState IPEBacktrace True
  setBacktraceMechanismState HasCallStackBacktrace True
  putStrLn "# catchAndThrow"
  putStrLn "# Original exception in the WhileHandling, rethrown exception has new backtrace.\n"
  catchAndPrintSomeException (catchAndThrow foo)
  putStrLn "# catchAndThrow'"
  putStrLn "# Original exception in the WhileHandling, rethrown exception has the new backtrace and also the old one.\n"
  catchAndPrintSomeException (catchAndThrow' foo)
  putStrLn "# catchAndRethrow"
  putStrLn "# No WhileHandling indirection, the catch becomes invisible.\n"
  catchAndPrintSomeException (catchAndRethrow foo)
