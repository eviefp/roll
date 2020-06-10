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
  hpHeadOverlay = self: super: {
    haskell = super.haskell // {
      packages = super.haskell.packages // {
        ghc8101 = super.haskell.packages.ghc8101.extend (selfGHC: superGHC: {
          extra = superGHC.extra_1_7_1;
          ghc-lib-parser = superGHC.ghc-lib-parser_8_10_1_20200412;
          ghc-lib-parser-ex = superGHC.callHackageDirect {
            pkg = "ghc-lib-parser-ex";
            ver = "8.10.0.5";
            sha256 = "0zygsy51hdl6p18x1qplggayjf6k4ykzr0nkyfrl09lp9df78f41";
          } {};
        });
      };
    };
  };

  pkgs = import sources.nixpkgs {
    overlays = [ overlay hpOverlay hpHeadOverlay ];
    config = {};
  };

  easy-ps = import sources.easy-purescript-nix { inherit pkgs; };

  ghcide = pkgs.haskell.packages.ghc883.callPackage ./nix/ghcide.nix {};

  hlint = pkgs.haskell.packages.ghc8101.callPackage ./nix/hlint.nix {};

  callNode2Nix = import ./nix/callNode2Nix.nix;

  self = {
    inherit (pkgs) niv;
    inherit pkgs easy-ps ghcide hlint;
    inherit callNode2Nix;
  };

in
  self
