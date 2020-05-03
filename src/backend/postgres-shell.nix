let
  inherit (import ../..) pkgs pgutil;
in
  pkgs.mkShell rec {
    nativeBuildInputs = [ pkgs.postgresql pkgs.dbmate ];
    NIX_PATH = "nixpkgs=${pkgs.path}";
    inherit (import ./exports.nix) PGHOST PGPORT PGDATABASE PGUSER PGPASSWORD DATABASE_URL;
    shellHook = ''
      function start() {
        ${pgutil.start_pg} || echo "PG start failed"
        dbmate up
      }

      function stop() {
        ${pgutil.stop_pg}
        rm -rf .pgdata
      }

      function restart() {
          stop_pg
          start_pg
      }

      echo "You can use 'start_pg' and 'stop_pg'."

      '';
  }
