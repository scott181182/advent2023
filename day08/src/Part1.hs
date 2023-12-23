module Main where

import System.Environment

import Data.Array (elems)
import Data.List ((!?))
import Data.List.Split (splitOn)
import Data.Map (Map, fromList, (!))
import Data.Maybe (mapMaybe)
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

stepsToEnd :: Puzzle -> (String, Int) -> Int
stepsToEnd _ ("ZZZ", step) = step
stepsToEnd puzzle (node, step) =
    let nextNode = followFullInstruction (network puzzle) node (instruction puzzle)
    in stepsToEnd puzzle (nextNode, step + length (instruction puzzle))

solvePart1 :: Puzzle -> Int
solvePart1 puzzle = stepsToEnd puzzle ("AAA", 0)



main :: IO ()
main = do
    args <- getArgs
    let filename = last args
    rawInput <- readFile filename
    case parseInput rawInput of
        Just input -> print $ solvePart1 input
        Nothing -> print "Parsing failed"
