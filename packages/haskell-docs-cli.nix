{ mkDerivation, aeson, ansi-wl-pprint, async, base, bytestring
, containers, directory, exceptions, extra, filepath, hashable
, haskeline, hoogle, html-conduit, http-client, http-client-tls
, http-types, lib, mtl, network-uri, optparse-applicative, process
, temporary, terminal-size, text, time, transformers, xml-conduit
, fetchFromGitHub
}:
mkDerivation {
  pname = "haskell-docs-cli";
  version = "1.0.0.0";
  src = fetchFromGitHub {
    owner = "lazamar";
    repo = "haskell-docs-cli";
    rev = "main";
    hash = "sha256-j/hOmRWEM23qoIQwbyOrRV51Kqi3RqhfsK9fDR9sSVA=";
  };
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
  jailbreak = false;
  doCheck = false;
  hyperlinkSource = false;
  homepage = "https://github.com/lazamar/haskell-docs-cli#readme";
  description = "Search Hoogle and navigate Hackage from the command line";
  license = lib.licenses.bsd3;
  mainProgram = "hdc";
}
