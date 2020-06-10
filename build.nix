let
  inherit (import ./.) pkgs;
  backend = import src/backend;
  database = import src/backend/database.nix;
  static-content = import src/static-content;
  roll-yaml = import nix/roll-yaml.nix {
    inherit pkgs;
    staticContentPath = "${static-content}";
  };
in
  pkgs.writeShellScript "roll"
    ''
      export DATABASE_URL=postgres://roll:roll@127.0.0.1:5432/roll?sslmode=disable
      export PGHOST="localhost"
      export PGPORT="5432"
      export PGDATABASE="roll"
      export PGUSER="roll"
      export PGPASSWORD="roll"
      export DATABASE_URL="postgres://roll:roll@127.0.0.1:5432/roll?sslmode=disable"

      TMP=`mktemp -d`
      cd $TMP
      cp -r ${database}/bin/* .
      ./pg-start.sh
      ${backend}/bin/backend ${roll-yaml}
    ''

