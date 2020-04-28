let
  sources = import ./nix/sources.nix;
  overlay = self: super: {
    niv = import sources."niv" {};
    haskellPackages = super.haskellPackages.extend (selfHP: superHP: {
      floskell = with self.haskell.lib; dontCheck (unmarkBroken superHP.floskell);
      monad-dijkstra = with self.haskell.lib; dontCheck (unmarkBroken superHP.monad-dijkstra);
    });
  };
  hpOverlay = self: super: {
    haskell = super.haskell // {
      packages = super.haskell.packages // {
        ghc883 = super.haskell.packages.ghc883.extend (selfGHC: superGHC: {
          hie-bios = with self.haskell.lib; dontCheck (unmarkBroken superGHC.hie-bios);
          haskell-lsp-types = self.haskell.packages.ghc883.callPackage ./haskell-lsp-types.nix {};
          haskell-lsp= self.haskell.packages.ghc883.callPackage ./haskell-lsp.nix {};
        });
      };
    };
  };

  pkgs = import sources.nixpkgs {
    overlays = [ overlay hpOverlay ];
    config = {};
  };
  ghcide = pkgs.haskell.packages.ghc883.callPackage ./ghcide.nix {};

in
  pkgs.mkShell rec {
    nativeBuildInputs = with pkgs; [
      cabal2nix
      haskell.compiler.ghc883
      haskellPackages.ghcid_0_8_6
      haskellPackages.floskell
      ghcide
    ];
    NIX_PATH = "nixpkgs=${pkgs.path}";
  }
