let
  inherit (import ../..) pkgs easy-ps;
  inherit (easy-ps) purs spago pscid;
in
  pkgs.mkShell {
    buildInputs = [ purs spago pscid ];
  }
