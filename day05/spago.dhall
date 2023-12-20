{ name = "aoc-day05"
, dependencies =
  [ "arrays"
  , "console"
  , "debug"
  , "effect"
  , "foldable-traversable"
  , "int64"
  , "integers"
  , "maybe"
  , "node-buffer"
  , "node-fs"
  , "node-process"
  , "prelude"
  , "strings"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
}
