module Main where

import IHP.Prelude
import qualified System.Directory as Directory
import qualified System.Environment as System
import IHP.IDE.CodeGen.ApplicationGenerator
import IHP.IDE.CodeGen.Controller (executePlan)
import Main.Utf8 (withUtf8)

main :: IO ()
main = withUtf8 do
    ensureIsInAppDirectory

    args <- map cs <$> System.getArgs
    case headMay args of
        Just "" -> usage
        Just applicationName -> do
            planOrError <- buildPlan applicationName
            case planOrError of
                Left error -> putStrLn error
                Right plan -> executePlan plan
        _ -> usage


usage :: IO ()
usage = putStrLn "Usage: new-application RESOURCE_NAME"


ensureIsInAppDirectory :: IO ()
ensureIsInAppDirectory = do
    mainHsExists <- Directory.doesFileExist "Main.hs"
    unless mainHsExists (fail "You have to be in a project directory to run the generator")
