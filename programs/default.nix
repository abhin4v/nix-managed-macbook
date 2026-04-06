{
  inputs,
  config,
  pkgs,
  pkgs-ghostty,
  # nixd,
  ...
}:

let
  leanHaskellBinary = pkgs.haskell.lib.compose.overrideCabal (old: {
    isLibrary = false;
    doHaddock = false;
    enableLibraryProfiling = false;
    enableSharedLibraries = false;
    enableSeparateBinOutput = true;
  });
  opaComplete = name: pkgs.haskellPackages.generateOptparseApplicativeCompletions [ name ];
  nixPackages = with pkgs; [
    config.nix.package
    niv
    nix
    nix-tree
    nixfmt-rfc-style
    nvd
    nil
    statix
    cachix
    nix-forecast
  ];
  networkingPackages = with pkgs; [
    dig
    openssh
    mosh
  ];
  cmdLineUtilPackages = with pkgs; [
    glow
    ranger
  ];
  miscPackages = with pkgs; [
    binutils
    brotli
    cabal2nix
    (opaComplete "cabal-plan" (leanHaskellBinary haskellPackages.cabal-plan))
    (opaComplete "hdc" (
      leanHaskellBinary (haskellPackages.callPackage ../packages/haskell-docs-cli.nix { })
    ))
    graphviz-nox
    iterm2
    jless
    mas
    fastfetch
    obsidian
    proselint
    shellcheck
  ];
  fonts = with pkgs; [
    fira-mono
    inconsolata
    jetbrains-mono
    roboto-mono
    source-code-pro
    (pkgs.callPackage ../packages/dm-mono.nix { dm-mono-src = "${inputs.dm-mono-font}"; })
    monaspace
    nerd-fonts.iosevka
    maple-mono.variable
  ];
in
{
  imports = [
    ./shared.nix
    ./fish.nix
    # ./vscode.nix
    ./zed.nix
  ];

  home.packages = nixPackages ++ networkingPackages ++ cmdLineUtilPackages ++ miscPackages ++ fonts;

  programs = {
    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };

    ghostty = {
      enable = true;
      package = pkgs-ghostty.ghostty;
      enableFishIntegration = true;
      enableBashIntegration = true;
      installBatSyntax = false;
      settings = {
        background-opacity = 0.95;
        command = "/etc/profiles/per-user/abhinav/bin/fish";
        copy-on-select = "clipboard";
        font-family = "PragmataPro Mono";
        font-size = 16;
        link-previews = true;
        macos-titlebar-style = "hidden";
        minimum-contrast = 1.05;
        mouse-hide-while-typing = true;
        quick-terminal-position = "right";
        quick-terminal-size = "50%";
        quit-after-last-window-closed = false;
        scrollback-limit = 100000000;
        shell-integration = "detect";
        theme = "aura";
        keybind = [ "global:cmd+shift+a=toggle_quick_terminal" ];
      };
    };
  };
}
