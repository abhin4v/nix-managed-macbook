{ system, nixpkgs }:
let
  hlib = pkgs.haskell.lib.compose;
  leanHaskellLibrary = hlib.overrideCabal (old: {
    doHaddock = false;
    enableLibraryProfiling = false;
  });
  pkgs = import nixpkgs {
    inherit system;
    overlays = [
      (final: prev: {
        haskellPackages = prev.haskellPackages.extend (
          hfinal: hprev: with hprev; {
            pandoc = leanHaskellLibrary pandoc_3_5;
            pandoc-lua-engine = leanHaskellLibrary pandoc-lua-engine_0_3_3;
            pandoc-server = leanHaskellLibrary pandoc-server_0_1_0_9;
            pandoc-cli = pandoc-cli_3_5;
            hslua-module-doclayout = leanHaskellLibrary hslua-module-doclayout_1_2_0;
            lpeg = leanHaskellLibrary lpeg_1_1_0;
            doclayout = doclayout_0_5;
            texmath = hlib.dontCheck (hlib.doJailbreak texmath_0_12_8_11);
            typst = hlib.doJailbreak typst_0_6;
            typst-symbols = hprev.callPackage ./typst-symbols.nix { };
            tls = tls_2_1_1;
            toml-parser = toml-parser_2_0_1_0;
            crypton-connection = crypton-connection_0_4_1;
          }
        );
      })
    ];
    config = { };
  };
in
pkgs.haskellPackages.pandoc-cli
