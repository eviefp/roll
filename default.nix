let
  sources = import ./nix/sources.nix;
  overlay = self: super: {
    niv = import sources.niv {};
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
          haskell-lsp-types = self.haskell.packages.ghc883.callPackage ./nix/haskell-lsp-types.nix {};
          haskell-lsp= self.haskell.packages.ghc883.callPackage ./nix/haskell-lsp.nix {};
        });
      };
    };
  };

  pkgs = import sources.nixpkgs {
    overlays = [ overlay hpOverlay ];
    config = {};
  };

  easy-ps = import sources.easy-purescript-nix { inherit pkgs; };

  ghcide = pkgs.haskell.packages.ghc883.callPackage ./ghcide.nix {};

  self = {
    inherit (pkgs) niv;
    inherit pkgs easy-ps ghcide;
  };

in
  self
