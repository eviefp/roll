{ pkgs ? import <nixpkgs> {}, staticContentPath }:
  pkgs.writeTextFile {
    name = "roll.yaml";
    text = ''
      database:
        hostname: "localhost"
        port: 5432
        username: "roll"
        password: "roll"
        dbName: "roll"

      http:
        httpPort: 8080
        staticContentPath: "${staticContentPath}"
    '';
  }
