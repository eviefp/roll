let
  sources = import ./nix/sources.nix;
  tooling = import sources.nix-tooling;
  pkgs = tooling.pkgs;
  gis = import sources.gitignore { inherit (pkgs) lib; };
  callNode2Nix = import ./nix/callNode2Nix.nix;
  haskell = tooling.haskell.ghc884;

  self = {
    inherit (pkgs) niv;
    inherit pkgs;
    inherit callNode2Nix;
    inherit (gis) gitignoreSource;
    inherit haskell;
    inherit (tooling) purescript;
  };

in
  self
