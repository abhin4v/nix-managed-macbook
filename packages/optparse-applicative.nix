{ mkDerivation, ansi-wl-pprint, base, lib, process, QuickCheck
, transformers, transformers-compat
}:
mkDerivation {
  pname = "optparse-applicative";
  version = "0.17.1.0";
  sha256 = "d179cb740139c55e6dada3c00efaea45f6853a1974d374668323bbbd07e0a5ef";
  revision = "1";
  editedCabalFile = "1mhyjlmb1hylmhv77w6gq663drpyiqd09w1x1vy4d63lr46mypyb";
  libraryHaskellDepends = [
    ansi-wl-pprint base process transformers transformers-compat
  ];
  testHaskellDepends = [ base QuickCheck ];
  doHaddock = false;
  jailbreak = true;
  doCheck = false;
  hyperlinkSource = false;
  homepage = "https://github.com/pcapriotti/optparse-applicative";
  description = "Utilities and combinators for parsing command line options";
  license = lib.licenses.bsd3;
}
