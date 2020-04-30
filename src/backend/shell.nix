let
  inherit (import ../..) pkgs ghcide postgres;
in
  pkgs.mkShell rec {
    nativeBuildInputs = with pkgs; [
      cabal2nix
      haskell.compiler.ghc883
      haskellPackages.ghcid_0_8_6
      haskellPackages.floskell
      ghcide
      postgresql
    ];
    NIX_PATH = "nixpkgs=${pkgs.path}";
  }
