{ mkDerivation, aeson, array, async, base, base16-bytestring
, binary, bytestring, containers, cryptohash-sha1, data-default
, deepseq, directory, extra, fetchgit, filepath, fuzzy, ghc
, ghc-boot, ghc-boot-th, ghc-check, ghc-paths
, ghc-typelits-knownnat, gitrev, haddock-library, hashable
, haskell-lsp, haskell-lsp-types, hie-bios, hslogger, lens
, lsp-test, mtl, network-uri, optparse-applicative
, parser-combinators, prettyprinter, prettyprinter-ansi-terminal
, QuickCheck, quickcheck-instances, regex-tdfa, rope-utf16-splay
, safe-exceptions, shake, sorted-list, stdenv, stm, syb, tasty
, tasty-expected-failure, tasty-hunit, tasty-quickcheck
, tasty-rerun, text, time, transformers, unix, unordered-containers
, utf8-string
}:
mkDerivation {
  pname = "ghcide";
  version = "0.1.0";
  src = fetchgit {
    url = "https://github.com/digital-asset/ghcide.git";
    sha256 = "0hhh0q4wv62g98a3c4l0d57jdmk4k1ilmzm2skr3b1w1y02ify24";
    rev = "78d4031f7cf119bf2a0d1fae6157d52d1fbd2063";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson array async base binary bytestring containers data-default
    deepseq directory extra filepath fuzzy ghc ghc-boot ghc-boot-th
    haddock-library hashable haskell-lsp haskell-lsp-types hslogger mtl
    network-uri prettyprinter prettyprinter-ansi-terminal regex-tdfa
    rope-utf16-splay safe-exceptions shake sorted-list stm syb text
    time transformers unix unordered-containers utf8-string
  ];
  executableHaskellDepends = [
    aeson base base16-bytestring binary bytestring containers
    cryptohash-sha1 data-default deepseq directory extra filepath ghc
    ghc-check ghc-paths gitrev hashable haskell-lsp haskell-lsp-types
    hie-bios hslogger optparse-applicative shake text
    unordered-containers
  ];
  testHaskellDepends = [
    aeson base bytestring containers directory extra filepath ghc
    ghc-typelits-knownnat haddock-library haskell-lsp haskell-lsp-types
    lens lsp-test network-uri parser-combinators QuickCheck
    quickcheck-instances rope-utf16-splay shake tasty
    tasty-expected-failure tasty-hunit tasty-quickcheck tasty-rerun
    text
  ];
  doHaddock = false;
  doCheck = false;
  homepage = "https://github.com/digital-asset/ghcide#readme";
  description = "The core of an IDE";
  license = stdenv.lib.licenses.asl20;
}
