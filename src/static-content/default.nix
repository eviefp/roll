let
  inherit (import ../..) pkgs callNode2Nix gitignoreSource;
  frontend = import ../frontend;
  rollNode2Nix = callNode2Nix {
    inherit pkgs;
    name = "rollNode2Nix";
    src = gitignoreSource ./.;
  };
  nodeEnv = import "${rollNode2Nix}/node-env.nix" {
    inherit (pkgs) stdenv python2 utillinux runCommand writeTextFile nodejs;
    libtool = null;
  };
  rollNode = import "${rollNode2Nix}/node-packages.nix" {
    inherit (pkgs) fetchurl fetchgit;
    inherit nodeEnv;
  };
  rollStatic = rollNode.package;
in
  pkgs.stdenv.mkDerivation rec {
    name = "roll-static";
    buildInputs = with pkgs; [ nodejs ];
    buildCommand = ''
      TMP=`mktemp -d`
      cd $TMP

      mkdir public
      cp -R ${rollStatic}/lib/node_modules/roll .
      cd roll
      npm run build
      cd ..
      mkdir -p $out
      cp -R public/* $out
      mkdir $out/js
      cp ${frontend}/index.js $out/js
      '';
  }
