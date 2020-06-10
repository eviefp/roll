let
  inherit (import ../..) pkgs ghcide hlint postgres;
  package = pkgs.cabal2nix ".";
in
  pkgs.haskell.packages.ghc883.callCabal2nix "." ./. {}
