let
  inherit (import ../..) pkgs easy-ps;
  inherit (easy-ps) purs spago pscid;
in
  pkgs.mkShell {
    buildInputs = [
      pkgs.nodejs # for npx to install purescript-language-server
      purs spago pscid
    ];
  }
