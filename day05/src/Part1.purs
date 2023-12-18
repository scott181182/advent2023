module Part1 where

import Prelude
import Effect (Effect)
import Effect.Class.Console (log)

greet :: String -> String
greet name = "Hello, " <> name <> "!"

main :: Effect Unit
main = do
    log (greet "AoC Day #5")