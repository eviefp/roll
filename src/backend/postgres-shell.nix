let
  inherit (import ../..) pkgs pgutil;
in
  pkgs.mkShell rec {
    nativeBuildInputs = [ pkgs.postgresql ];
    NIX_PATH = "nixpkgs=${pkgs.path}";
    shellHook = ''
      function load_pg() {
        export PGHOST=localhost
        export PGPORT=5432
        export PGDATABASE=test_db
        export PGUSER=test_user
        export PGPASSWORD=test_pass
      }

      function start_pg() {
        load_pg
        ${pgutil.start_pg} || echo "PG start failed"
        # TODO: migrate data
      }

      function stop_pg() {
        ${pgutil.stop_pg}
        rm -rf .pgdata
      }

      echo "You can use 'start_pg' and 'stop_pg'."

      '';
  }
