module Part2 where

import Prelude
import Control.Apply
import Effect (Effect)
import Effect.Console (log, logShow)

import Data.Array (concat, drop, find, head, last, singleton, splitAt, tail, (:), (!!))
import Data.Foldable (minimum, foldl)
import Data.Int64 (Int64, fromString)
import Data.Maybe
import Data.String (split)
import Data.String.Pattern (Pattern(..))
import Data.Traversable (sequence)

import Node.Encoding (Encoding(..))
import Node.FS.Sync (readTextFile)
import Node.Process (argv)



type NumberRange =
    { start :: Int64
    , end :: Int64
    }
type MapRange =
    { source :: Int64
    , destination :: Int64
    , size :: Int64
    }
type InputFile =
    { seeds :: Array NumberRange
    , maps :: Array (Array MapRange)
    }



--
-- Parsing Logic
--
groupPairs :: Array Int64 -> Maybe (Array NumberRange)
groupPairs [] = Just []
groupPairs [_] = Nothing
groupPairs arr = do
    { before, after } <- pure $ splitAt 2 arr
    a <- before !! 0
    b <- before !! 1
    later <- groupPairs after
    pure $ { start: a, end: a + b } : later

parseSeeds :: String -> Maybe (Array NumberRange)
parseSeeds line = do
    nums <- sequence $ map fromString (drop 1 $ split (Pattern " ") line)
    groupPairs nums

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
mapSeedRangeInRange :: MapRange -> NumberRange -> NumberRange
mapSeedRangeInRange range nums =
    { start: nums.start + range.destination - range.source
    , end: nums.end + range.destination - range.source
    }

type SeedMapAccumulator =
    { mapped :: Array NumberRange
    , unmapped :: Array NumberRange
    }
intersectAndMapRange :: NumberRange -> MapRange -> SeedMapAccumulator
intersectAndMapRange nums range
    -- Number range is a proper subset of the map range
    | nums.start >= range.source && nums.end <= (range.source + range.size) =
        let
            mappedRange = mapSeedRangeInRange range nums
        in
            { mapped: [ mappedRange ], unmapped: [] }
    -- Map range is a proper subset of the number range
    | nums.start < range.source && nums.end > (range.source + range.size) =
        let
            lowerRange = { start: nums.start, end: range.source }
            upperRange = { start: range.source + range.size, end: nums.end }
            mappedRange = mapSeedRangeInRange range { start: range.source, end: range.source + range.size }
        in
            { mapped: [ mappedRange ], unmapped: [ lowerRange, upperRange ] }
    -- Partial intersection on bottom
    | nums.start < range.source && nums.end > range.source =
        let
            lowerRange = { start: nums.start, end: range.source }
            mappedRange = mapSeedRangeInRange range { start: range.source, end: nums.end }
        in
            { mapped: [ mappedRange ], unmapped: [ lowerRange ] }
    -- Partial intersection on top
    | nums.start < (range.source + range.size) && nums.end > (range.source + range.size) =
        let
            upperRange = { start: range.source + range.size, end: nums.end }
            mappedRange = mapSeedRangeInRange range { start: nums.start, end: range.source + range.size }
        in
            { mapped: [ mappedRange ], unmapped: [ upperRange ] }
    -- No intersection
    | otherwise =
        { mapped: [], unmapped: [nums] }

mergeAccumulators :: SeedMapAccumulator -> SeedMapAccumulator -> SeedMapAccumulator
mergeAccumulators acc1 acc2 =
    let
        mappedRanges = concat [ acc1.mapped, acc2.mapped ]
        unmappedRanges = concat [ acc1.unmapped, acc2.unmapped ]
    in
        { mapped: mappedRanges, unmapped: unmappedRanges }

accumulateSeedsThroughRange :: SeedMapAccumulator -> MapRange -> SeedMapAccumulator
accumulateSeedsThroughRange oldAcc range =
    let
        mappedAcc = { mapped: oldAcc.mapped, unmapped: [] }
    in
        foldl (\acc nums -> mergeAccumulators acc $ intersectAndMapRange nums range) mappedAcc oldAcc.unmapped 

mapSeedRangeInRanges :: Array MapRange -> NumberRange -> Array NumberRange
mapSeedRangeInRanges maps seedRange =
    let
        acc = foldl accumulateSeedsThroughRange { mapped: [], unmapped: [ seedRange ] } maps
    in
        concat [ acc.mapped, acc.unmapped ]



mapSeedRangessInRanges :: Array NumberRange -> Array MapRange -> Array NumberRange
mapSeedRangessInRanges seedRanges mapRanges =
    concat $ map (mapSeedRangeInRanges mapRanges) seedRanges

solvePart2 :: String -> Maybe Int64
solvePart2 rawInput = do
    input <- parseInput rawInput
    minimum $ map _.start (foldl mapSeedRangessInRanges input.seeds input.maps)



main :: Effect Unit
main = do
    args <- argv
    case last args of
        Just filename -> do
            log filename
            rawInput <- readTextFile UTF8 filename
            logShow $ parseInput rawInput
            logShow $ solvePart2 rawInput
        Nothing -> log "No file given"