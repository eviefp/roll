let
  inherit (import ../..) pkgs purescript gitignoreSource;
in
  pkgs.stdenv.mkDerivation rec {
    name = "roll-frontend";
    src = gitignoreSource ./src;
    buildInputs = [ purescript.spago ];
    buildCommand = ''
      mkdir -p $out
      echo "hello" > $out/index.js
      # spago bundle-app --to $out/index.js
      '';
  }
