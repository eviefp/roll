let
  inherit (import ../..) pkgs easy-ps;
  spagoPkgs = import ./spago-packages.nix { inherit pkgs; };
  removeHashBang = drv: drv.overrideAttrs (oldAttrs: {
          buildCommand = builtins.replaceStrings ["#!/usr/bin/env"] [""] oldAttrs.buildCommand;
        });
in
  pkgs.stdenv.mkDerivation rec {
    name = "roll-frontend";
    src = ./src;
    buildInputs = with easy-ps; [ purs spago pkgs.fish ];
    buildCommand = ''
      ${removeHashBang spagoPkgs.installSpagoStyle} # == spago2nix install
      fish -c "purs compile .spago/*/*/src/**.purs $src/**.purs"
      mkdir -p $out
      purs bundle "output/*/*.js" -m Main --main Main -o $out/index.js
      '';
  }
