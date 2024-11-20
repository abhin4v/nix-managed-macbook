{ mkDerivation, base, lib, text }:
mkDerivation {
  pname = "typst-symbols";
  version = "0.1.6";
  sha256 = "947ff2a09549a6a0387327e6b15c9219947be67ebe5fb190d1fb98495d7e429d";
  libraryHaskellDepends = [ base text ];
  doHaddock = false;
  doCheck = false;
  hyperlinkSource = false;
  homepage = "https://github.com/jgm/typst-symbols";
  description = "Symbol and emoji lookup for typst language";
  license = lib.licenses.mit;
}
