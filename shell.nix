let
  sources = import ./nix/sources.nix;
  overlay = self: super: {
    niv = import sources."niv" {};
  };
  hpOverlay = self: super: {
    haskellPackages = super.haskellPackages.override (selfHS: superHS: {
      hie-bios = self.haskell.lib.unmarkBroken superHS.hie-bios;
    });
  };

  pkgs = import sources.nixpkgs {
    overlays = [ overlay hpOverlay ];
    config = {};
  };
  ghcide = pkgs.haskell.packages.ghc883.callPackage ./ghcide.nix {};

in
  pkgs.mkShell rec {
    nativeBuildInputs = with pkgs; [
      haskellPackages.cabal2nix
      haskell.compiler.ghc883
      haskellPackages.ghcid_0_8_6
      ghcide
    ];
  }
