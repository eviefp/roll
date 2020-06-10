let
  inherit (import ../..) pkgs;
  dependencies = [ pkgs.postgresql pkgs.dbmate ];
in
  pkgs.stdenv.mkDerivation rec {
    name = "roll-database";
    nativeBuildInputs = [ pkgs.makeWrapper ];
    src = ../..;
    installPhase = ''
      mkdir -p $out/bin
      cp -R $src/script/pg* $out/bin
      cp -R $src/src/backend/db $out/bin
      ls -la $out/bin/pg-start.sh
      wrapProgram "$out/bin/pg-start.sh" --prefix PATH ":" "${pkgs.lib.makeBinPath dependencies}"
      wrapProgram "$out/bin/pg-stop.sh" --prefix PATH ":" "${pkgs.lib.makeBinPath dependencies}"
    '';
  }
