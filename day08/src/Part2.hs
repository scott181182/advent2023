module Main where

import System.Environment

import Data.Array (elems)
import Data.List ((!?))
import Data.List.Split (splitOn)
import Data.Map (Map, fromList, keys, size, (!))
import Data.Maybe (mapMaybe)
import Debug.Trace (trace)
import Text.Regex.PCRE (Regex, makeRegex, matchOnceText)


data Direction = R | L
    deriving (Show)
data Puzzle = Puzzle { instruction :: [Direction],
                           network :: Map String (String, String) }
    deriving (Show)



-- 
-- Parsing Logic
-- 
char2direction :: Char -> Maybe Direction
char2direction 'R' = Just R
char2direction 'L' = Just L
char2direction _ = Nothing

parseInstruction :: String -> [Direction]
parseInstruction = mapMaybe char2direction

parseNetworkNode :: String -> Maybe (String, (String, String))
parseNetworkNode line = do
    let lineRegex = makeRegex "^(\\w+) = \\((\\w+), (\\w+)\\)$" :: Regex
    matchObj <- matchOnceText lineRegex line
    let (_, matchArr, _) = matchObj
    let matches = fst <$> elems matchArr
    name <- matches !? 1
    left <- matches !? 2
    right <- matches !? 3
    pure (name, (left, right))

parseNetwork :: String -> Map String (String, String)
parseNetwork lines = fromList $ mapMaybe parseNetworkNode (splitOn "\n" lines)

parseInput :: String -> Maybe Puzzle
parseInput input = do
    let rawSplit = splitOn "\n\n" input
    rawInstruction <- rawSplit !? 0
    let instruction = parseInstruction rawInstruction
    rawNetwork <- rawSplit !? 1
    let network = parseNetwork rawNetwork
    pure Puzzle{ instruction = instruction, network = network }


-- 
-- Solution Logic
-- 
followStepInstruction :: Map String (String, String) -> String -> Direction -> String
followStepInstruction network start L = fst $ network ! start
followStepInstruction network start R = snd $ network ! start

followFullInstruction :: Map String (String, String) -> String -> [Direction] -> String
followFullInstruction network = foldl (followStepInstruction network)
followFullInstructionForNodes :: Map String (String, String) -> [String] -> [Direction] -> [String]
followFullInstructionForNodes network nodes directions = map (\node -> followFullInstruction network node directions) nodes

findRepeatLoopStart :: Puzzle -> (String, Int) -> (String, Int)
findRepeatLoopStart puzzle (node, step)
    | last node == 'Z' = (node, step)
    | otherwise = findRepeatLoopStart puzzle (followFullInstruction (network puzzle) node (instruction puzzle), step + 1)

findRepeatLoopLength :: Puzzle -> String -> (String, Int) -> (String, Int)
findRepeatLoopLength puzzle goal (node, step)
    | node == goal && step > 0 = (node, step)
    | otherwise = findRepeatLoopLength puzzle goal (followFullInstruction (network puzzle) node (instruction puzzle), step + 1)

findRepeatLoop :: Puzzle -> String -> (String, Int, Int)
findRepeatLoop puzzle startNode =
    let
        (endNode, startStep) = findRepeatLoopStart puzzle (startNode, 0)
        (_, loopLength) = findRepeatLoopLength puzzle endNode (endNode, 0)
    in
        (endNode, startStep, loopLength)


stepsToEnd :: Puzzle -> ([String], Int) -> Int
stepsToEnd puzzle (nodes, step)
    -- End Condition
    | all (\node -> last node == 'Z') nodes = step
    -- No Solution
    | step > size (network puzzle) * length (instruction puzzle) = -1
    -- Iterate
    | otherwise =
        let
            nextNodes = followFullInstructionForNodes (network puzzle) nodes (instruction puzzle)
            endNodes = length $ filter (\node -> last node == 'Z') nodes
        in
            if endNodes >= 2
                then trace (show (show step ++ " -> " ++ show nodes)) $ stepsToEnd puzzle (nextNodes, step + length (instruction puzzle))
                else stepsToEnd puzzle (nextNodes, step + length (instruction puzzle))

solvePart2 :: Puzzle -> Int
solvePart2 puzzle =
    let
        startingNodes = filter (\node -> last node == 'A') $ keys (network puzzle)
        loops = map (findRepeatLoop puzzle) startingNodes
        stepGcd = product $ map (\(_, _, loopSize) -> loopSize) loops
    in
        stepGcd * length (instruction puzzle)



main :: IO ()
main = do
    args <- getArgs
    let filename = last args
    rawInput <- readFile filename
    case parseInput rawInput of
        Just input -> do
            -- Knowing that all loop offsets and lengths match, and all loop lengths are (co-)prime...
            print $ "Answer: " ++ show (solvePart2 input)
        Nothing -> print "Parsing failed"
