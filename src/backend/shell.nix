let
  inherit (import ../..) pkgs ghcide postgres hlint;
in
  pkgs.mkShell rec {
    nativeBuildInputs = with pkgs; [
      cabal2nix
      haskell.compiler.ghc883
      haskellPackages.ghcid
      haskellPackages.floskell
      ghcide
      hlint
      postgresql
      dbmate
    ];
    NIX_PATH = "nixpkgs=${pkgs.path}";
    inherit (import ./exports.nix) PGHOST PGPORT PGDATABASE PGUSER PGPASSWORD DATABASE_URL;
  }
