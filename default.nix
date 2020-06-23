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
          ghc-check = self.haskell.packages.ghc883.callPackage ./nix/ghc-check.nix {};
          hie-bios = self.haskell.packages.ghc883.hie-bios_0_5_0;
          haskell-lsp-types = self.haskell.packages.ghc883.haskell-lsp-types_0_22_0_0;
          haskell-lsp = self.haskell.packages.ghc883.haskell-lsp_0_22_0_0;
        });
      };
    };
  };

  pkgs = import sources.nixpkgs {
    overlays = [ overlay hpOverlay ];
    config = {};
  };
  gis = import sources.gitignore { inherit (pkgs) lib; };

  easy-ps = import sources.easy-purescript-nix { inherit pkgs; };

  ghcide = pkgs.haskell.packages.ghc883.callPackage ./nix/ghcide.nix {};

  hlint = pkgs.haskell.packages.ghc883.hlint;

  callNode2Nix = import ./nix/callNode2Nix.nix;

  self = {
    inherit (pkgs) niv;
    inherit pkgs easy-ps ghcide hlint;
    inherit callNode2Nix;
    inherit (gis) gitignoreSource;
  };

in
  self
