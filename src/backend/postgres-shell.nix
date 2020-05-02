let
  inherit (import ../..) pkgs pgutil;
in
  pkgs.mkShell rec {
    nativeBuildInputs = [ pkgs.postgresql pkgs.dbmate ];
    NIX_PATH = "nixpkgs=${pkgs.path}";
    shellHook = ''
      function load_pg() {
        export PGHOST=localhost
        export PGPORT=5432
        export PGDATABASE=roll
        export PGUSER=roll
        export PGPASSWORD=roll
        export DATABASE_URL=postgres://roll:roll@127.0.0.1:5432/roll?sslmode=disable
      }

      function start_pg() {
        load_pg
        ${pgutil.start_pg} || echo "PG start failed"
        dbmate up
      }

      function stop_pg() {
        ${pgutil.stop_pg}
        rm -rf .pgdata
      }

      function restart_pg() {
          stop_pg
          start_pg
      }

      echo "You can use 'start_pg' and 'stop_pg'."

      '';
  }
