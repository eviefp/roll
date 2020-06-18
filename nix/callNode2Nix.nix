{ pkgs ? import <nixpkgs> {}, name, src }:
  pkgs.stdenv.mkDerivation {
    inherit name src;
    nativeBuildInputs = [ pkgs.nodePackages.node2nix ];
    phases = [ "buildPhase" "installPhase" ];
    buildPhase = ''
      mkdir tmp
      cp -R $src/* tmp
      cd tmp
      rm *.nix
      node2nix --development --nodejs-10 --input package.json --lock package-lock.json
    '';
    installPhase = ''
      mkdir -p $out
      cp -R * $out
    '';
  }
