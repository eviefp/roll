{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "my-project"
, dependencies =
  [ "aff"
  , "affjax"
  , "console"
  , "effect"
  , "generics-rep"
  , "halogen"
  , "halogen-hooks"
  , "numbers"
  , "profunctor-lenses"
  , "psci-support"
  , "random"
  , "record-extra"
  , "simple-json"
  , "strings"
  , "web-dom"
  , "web-html"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
