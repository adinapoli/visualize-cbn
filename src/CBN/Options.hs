module CBN.Options (
    Options(..)
  , getOptions
  ) where

import Options.Applicative
import CBN.Trace

data Options = Options {
      optionsInput     :: FilePath
    , optionsShowTrace :: Bool
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
    <$> (flag True False $ mconcat [
             long "show-adjacent-beta"
           , help "Don't collapse adjacent beta steps"
           ])
    <*> (option auto $ mconcat [
             long "max-num-steps"
           , help "Maximum number of steps"
           , showDefault
           , value 1000
           ])
