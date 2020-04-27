let
  sources = import ./nix/sources.nix;
  overlay = _: pkgs: {
    niv = import sources."niv" {};
  };
  haskell-nix = import sources."haskell.nix";

  pkgs = import sources."nixpkgs" {
    # overlays = [ overlay ];
    config = {
      packageOverides = pkgs: rec {
        haskellPackages = pkgs.haskellPackages.override {
          overrides = haskellPackagesNew: haskellPackagesOld: rec {
            hie-bios = pkgs.haskell.lib.unmarkBroken pkgs.haskellPackages.hie-bios;
          };
        };
      };
    };
  };
  ghcide = pkgs.haskell.packages.ghc883.callPackage ./ghcide.nix {};

in
  pkgs.mkShell rec {
    nativeBuildInputs = [
      pkgs.haskellPackages.cabal2nix
      pkgs.haskell.compiler.ghc883
      pkgs.haskellPackages.ghcid_0_8_6
      ghcide
    ];
    NIX_PATH = "nixpkgs=${pkgs.path}";
  }
