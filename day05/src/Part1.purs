module Part1 where

import Prelude
import Control.Apply
import Effect (Effect)
import Effect.Console (log, logShow)

import Data.Array (drop, find, head, last, tail, (!!))
import Data.Foldable (minimum, foldl)
import Data.Int64 (Int64, fromString)
import Data.Maybe
import Data.String (split)
import Data.String.Pattern (Pattern(..))
import Data.Traversable (sequence)

import Node.Encoding (Encoding(..))
import Node.FS.Sync (readTextFile)
import Node.Process (argv)



type MapRange =
    { source :: Int64
    , destination :: Int64
    , size :: Int64
    }
type InputFile =
    { seeds :: Array Int64
    , maps :: Array (Array MapRange)
    }



--
-- Parsing Logic
--
parseSeeds :: String -> Maybe (Array Int64)
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



--
-- Solving Logic
--
isSeedInRange :: Int64 -> MapRange -> Boolean
isSeedInRange seed range =
    seed >= range.source && seed < range.source + range.size
mapSeedInRange :: Int64 -> MapRange -> Int64
mapSeedInRange seed range = seed - range.source + range.destination

mapSeedInRanges :: Array MapRange -> Int64 -> Int64
mapSeedInRanges maps seed =
    maybe seed (mapSeedInRange seed) (find (isSeedInRange seed) maps)

mapSeedsInRanges :: Array Int64 -> Array MapRange -> Array Int64
mapSeedsInRanges seeds ranges =
    map (mapSeedInRanges ranges) seeds

solvePart1 :: String -> Maybe Int64
solvePart1 rawInput = do
    input <- parseInput rawInput
    minimum (foldl mapSeedsInRanges input.seeds input.maps)



main :: Effect Unit
main = do
    args <- argv
    case last args of
        Just filename -> do
            log filename
            rawInput <- readTextFile UTF8 filename
            -- logShow $ parseInput rawInput
            logShow $ solvePart1 rawInput
        Nothing -> log "No file given"