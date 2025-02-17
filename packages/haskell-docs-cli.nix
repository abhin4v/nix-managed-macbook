{ mkDerivation, aeson, ansi-wl-pprint, async, base, bytestring
, containers, directory, exceptions, extra, filepath, hashable
, haskeline, hoogle, html-conduit, http-client, http-client-tls
, http-types, lib, mtl, network-uri, optparse-applicative, process
, temporary, terminal-size, text, time, transformers, xml-conduit
}:
mkDerivation {
  pname = "haskell-docs-cli";
  version = "1.0.0.0";
  sha256 = "c19d975dd499b5a461e2a45faa99e933bba7901141321dc9c106b7c6e7a3e267";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson ansi-wl-pprint async base bytestring containers directory
    exceptions extra filepath hashable haskeline hoogle html-conduit
    http-client http-client-tls http-types mtl network-uri
    optparse-applicative process temporary terminal-size text time
    transformers xml-conduit
  ];
  executableHaskellDepends = [
    aeson ansi-wl-pprint async base bytestring containers directory
    exceptions extra filepath hashable haskeline hoogle html-conduit
    http-client http-client-tls http-types mtl network-uri
    optparse-applicative process temporary terminal-size text time
    transformers xml-conduit
  ];
  testHaskellDepends = [
    aeson ansi-wl-pprint async base bytestring containers directory
    exceptions extra filepath hashable haskeline hoogle html-conduit
    http-client http-client-tls http-types mtl network-uri
    optparse-applicative process temporary terminal-size text time
    transformers xml-conduit
  ];
  doHaddock = false;
  jailbreak = true;
  doCheck = false;
  hyperlinkSource = false;
  homepage = "https://github.com/lazamar/haskell-docs-cli#readme";
  description = "Search Hoogle and navigate Hackage from the command line";
  license = lib.licenses.bsd3;
  mainProgram = "hdc";
}
