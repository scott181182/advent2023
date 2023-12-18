module Part1 where

import Prelude
import Control.Apply
import Effect (Effect)
import Effect.Console (log, logShow)

import Data.Array (drop, head, last, tail, (!!))
import Data.Int (fromString)
import Data.Maybe
import Data.String (split)
import Data.String.Pattern (Pattern(..))
import Data.Traversable (sequence)

import Node.Encoding (Encoding(..))
import Node.FS.Sync (readTextFile)
import Node.Process (argv)



type MapRange =
    { source :: Int
    , destination :: Int
    , size :: Int
    }
type InputFile =
    { seeds :: Array Int
    , maps :: Array (Array MapRange)
    }

-- testParse :: String -> Array String
-- testParse input = split (Pattern "\n\n") input

parseSeeds :: String -> Maybe (Array Int)
parseSeeds line = sequence $ map fromString (drop 1 $ split (Pattern " ") line)

parseMapRange :: String -> Maybe MapRange
parseMapRange line = do
    nums <- sequence $ fromString <$> split (Pattern " ") line
    dst <- nums !! 0
    src <- nums !! 1
    size <- nums !! 2
    pure { source: src, destination: dst, size: size }

parseMapGroup :: String -> Maybe (Array MapRange)
parseMapGroup lines =
    sequence $ map parseMapRange (drop 1 $ split (Pattern "\n") lines)

parseInput :: String -> Maybe InputFile
parseInput input = do
    groups <- pure $ split (Pattern "\n\n") input
    seedGroup <- head groups
    restGroups <- tail groups
    seeds <- parseSeeds seedGroup
    maps <- sequence $ parseMapGroup <$> restGroups
    pure { seeds: seeds, maps: maps }


greet :: String -> String
greet name = "Hello, " <> name <> "!"

main :: Effect Unit
main = do
    args <- argv
    case last args of
        Just filename -> do
            log filename
            rawInput <- readTextFile UTF8 filename
            logShow $ parseInput rawInput
        Nothing -> log "No file given"