let
  inherit (import ../..) pkgs haskell gitignoreSource;
in
  tooling.haskell.callCabal2nix
    "roll-backend"
    (gitignoreSource ./.)
    { staticBuildInputs = [ pkgs.zlib ];
    }
