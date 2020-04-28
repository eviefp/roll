{ mkDerivation, aeson, async, attoparsec, base, bytestring
, containers, data-default, directory, fetchgit, filepath, hashable
, haskell-lsp-types, hslogger, hspec, hspec-discover, lens, mtl
, network-uri, QuickCheck, quickcheck-instances, rope-utf16-splay
, sorted-list, stdenv, stm, temporary, text, time
, unordered-containers
}:
mkDerivation {
  pname = "haskell-lsp";
  version = "0.21.0.0";
  src = fetchgit {
    url = "https://github.com/alanz/haskell-lsp.git";
    sha256 = "0qp9g4hscqqb40pcbm2gdyynz06h3j57kgjfklxk0y3p5dl07na2";
    rev = "c19ed85e9da8516784415c7144331cabe9e89bf8";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson async attoparsec base bytestring containers data-default
    directory filepath hashable haskell-lsp-types hslogger lens mtl
    network-uri rope-utf16-splay sorted-list stm temporary text time
    unordered-containers
  ];
  testHaskellDepends = [
    aeson base bytestring containers data-default directory filepath
    hashable hspec lens network-uri QuickCheck quickcheck-instances
    rope-utf16-splay sorted-list stm text unordered-containers
  ];
  testToolDepends = [ hspec-discover ];
  homepage = "https://github.com/alanz/haskell-lsp";
  description = "Haskell library for the Microsoft Language Server Protocol";
  license = stdenv.lib.licenses.mit;
}
