let
  inherit (import ../..) pkgs haskell;
in
  pkgs.mkShell {
    nativeBuildInputs = [ pkgs.postgresql pkgs.dbmate pkgs.zlib ] ++ haskell.defaultInputs;
    NIX_PATH = "nixpkgs=${pkgs.path}";
    inherit (import ./exports.nix) PGHOST PGPORT PGDATABASE PGUSER PGPASSWORD DATABASE_URL;
  }
