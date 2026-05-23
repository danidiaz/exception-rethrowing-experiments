{-# LANGUAGE TypeAbstractions #-}
module PrettyException (
    prettyPrintSomeException,
    catchAndPrintSomeException
    ) where

import Control.Exception
import Control.Exception.Backtrace
import Control.Exception.Context
import Type.Reflection
import Data.List (intercalate)
import Data.Tree (Tree(..), drawTree)

prettyPrintSomeException :: SomeException -> IO ()
prettyPrintSomeException e = 
    putStrLn $ drawTree $ someExceptionToTree e 

someExceptionToTree :: SomeException -> Tree String
someExceptionToTree e = 
    let context = someExceptionContext e
        whileHandlings = getExceptionAnnotations @WhileHandling context
        backtraces = getExceptionAnnotations @Backtraces context
    in case e of 
        SomeException @innert _ ->
            let eRep = typeRep @innert
             in Node (show $ eRep) (
                    (whileHandlingToTree <$> whileHandlings)
                    ++ 
                    (backtracesToTree <$> backtraces))
    where 
    whileHandlingToTree (WhileHandling e') = 
        Node "WhileHandling" [someExceptionToTree e']
    backtracesToTree backtraces = 
        Node ("Backtrace: " ++ (intercalate "/" $ lines $ displayBacktraces backtraces)) []

catchAndPrintSomeException :: IO () -> IO ()
catchAndPrintSomeException action =
    catch action prettyPrintSomeException

