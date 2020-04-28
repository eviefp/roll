{ mkDerivation, aeson, base, binary, bytestring, data-default
, deepseq, fetchgit, filepath, hashable, lens, network-uri
, scientific, stdenv, text, unordered-containers
}:
mkDerivation {
  pname = "haskell-lsp-types";
  version = "0.21.0.0";
  src = fetchgit {
    url = "https://github.com/alanz/haskell-lsp.git";
    sha256 = "0qp9g4hscqqb40pcbm2gdyynz06h3j57kgjfklxk0y3p5dl07na2";
    rev = "c19ed85e9da8516784415c7144331cabe9e89bf8";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/haskell-lsp-types; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson base binary bytestring data-default deepseq filepath hashable
    lens network-uri scientific text unordered-containers
  ];
  homepage = "https://github.com/alanz/haskell-lsp";
  description = "Haskell library for the Microsoft Language Server Protocol, data types";
  license = stdenv.lib.licenses.mit;
}
