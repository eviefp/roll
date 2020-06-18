let
  inherit (import ../..) pkgs easy-ps;
  inherit (easy-ps) purs spago pscid spago2nix;
in
  pkgs.mkShell {
    buildInputs = [
      pkgs.nodejs # for npx to install purescript-language-server
      purs spago pscid
      spago2nix
    ];
  }
