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
      dbmate
    ];
    NIX_PATH = "nixpkgs=${pkgs.path}";
    inherit (import ./exports.nix) PGHOST PGPORT PGDATABASE PGUSER PGPASSWORD DATABASE_URL;
  }
