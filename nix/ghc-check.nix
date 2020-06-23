{ mkDerivation, base, containers, directory, fetchgit, filepath
, ghc, ghc-paths, process, safe-exceptions, stdenv
, template-haskell, transformers
}:
mkDerivation {
  pname = "ghc-check";
  version = "0.5.0.1";
  src = fetchgit {
    url = "https://github.com/pepeiborra/ghc-check";
    sha256 = "0bvmvmdikc0d0f7cys8xr6n9mq2b69ynalc784snnflx8kvrf5ri";
    rev = "28ad1ea15f7b694f99e93c8265880f5b25b1fbdb";
    fetchSubmodules = true;
  };
  libraryHaskellDepends = [
    base containers directory filepath ghc ghc-paths process
    safe-exceptions template-haskell transformers
  ];
  description = "detect mismatches between compile-time and run-time versions of the ghc api";
  license = stdenv.lib.licenses.bsd3;
}
