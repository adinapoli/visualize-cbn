module CBN.Options (
    Options(..)
  , getOptions
  ) where

import Options.Applicative
import CBN.Trace

data Options = Options {
      optionsInput     :: FilePath
    , optionsShowTrace :: Bool
    , optionsGC        :: Bool
    , optionsSummarize :: SummarizeOptions
    , optionsJsOutput  :: Maybe FilePath
    , optionsJsName    :: String
    }
  deriving (Show)

getOptions :: IO Options
getOptions = execParser $ info (helper <*> parseOptions) fullDesc

parseOptions :: Parser Options
parseOptions = Options
    <$> (strOption $ mconcat [
             short 'i'
           , help "Input file"
           ])
    <*> (switch $ mconcat [
             long "show-trace"
           , help "Write trace to console"
           ])
    <*> (switch $ mconcat [
             long "gc"
           , help "GC after each step"
           ])
    <*> parseSummarizeOptions
    <*> (optional . strOption $ mconcat [
             long "javascript"
           , help "Generate JavaScript output"
           , metavar "FILE"
           ])
    <*> (strOption $ mconcat [
             long "javascript-function"
           , help "Function name prefix in the JavaScript output"
           , metavar "NAME"
           , showDefault
           , value "cbn"
           ])

parseSummarizeOptions :: Parser SummarizeOptions
parseSummarizeOptions = SummarizeOptions
    <$> (switch $ mconcat [
             long "collapse-beta"
           , help "Collapse adjacent beta steps"
           ])
    <*> (option auto $ mconcat [
             long "max-num-steps"
           , help "Maximum number of steps"
           , showDefault
           , value 1000
           ])
    <*> (switch $ mconcat [
             long "hide-prelude"
           , help "Hide the prelude from the help"
           ])
    <*> (switch $ mconcat [
             long "hide-gc"
           , help "Hide GC steps"
           ])
