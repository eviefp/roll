{ mkDerivation, aeson, ansi-terminal, base, bytestring, cmdargs
, containers, cpphs, data-default, directory, extra, fetchgit
, file-embed, filepath, filepattern, ghc-lib-parser
, ghc-lib-parser-ex, hscolour, process, refact, stdenv, text
, transformers, uniplate, unordered-containers, utf8-string, vector
, yaml
}:
mkDerivation {
  pname = "hlint";
  version = "3.0.4";
  src = fetchgit {
    url = "https://github.com/ndmitchell/hlint.git";
    sha256 = "0z74g0xz2rcqqvilmy8dlljj4jhwfs2dkims3nclrryamzak94b6";
    rev = "510277ee0d24d17c9cb33d2832fe089ee8c29631";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    aeson ansi-terminal base bytestring cmdargs containers cpphs
    data-default directory extra file-embed filepath filepattern
    ghc-lib-parser ghc-lib-parser-ex hscolour process refact text
    transformers uniplate unordered-containers utf8-string vector yaml
  ];
  executableHaskellDepends = [ base ];
  homepage = "https://github.com/ndmitchell/hlint#readme";
  description = "Source code suggestions";
  license = stdenv.lib.licenses.bsd3;
}
