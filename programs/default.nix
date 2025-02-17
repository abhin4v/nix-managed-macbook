{
  inputs,
  config,
  pkgs,
  pkgs-ghostty,
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
    nixd
    statix
    cachix
    nix-output-monitor
  ];
  networkingPackages = with pkgs; [
    curl
    dig
    httpie
    openssh
    mosh
  ];
  cmdLineUtilPackages = with pkgs; [
    bash
    broot
    coreutils-full
    fd
    glow
    gnugrep
    less
    ranger
    tree
    unixtools.watch
  ];
  miscPackages = with pkgs; [
    as-tree
    binutils
    brotli
    cabal2nix
    (opaComplete "cabal-plan" (leanHaskellBinary haskellPackages.cabal-plan))
    (opaComplete "hdc" (
      leanHaskellBinary (
        pkgs.haskellPackages.callPackage ../packages/haskell-docs-cli.nix {
          optparse-applicative = pkgs.haskellPackages.callPackage ../packages/optparse-applicative.nix { };
        }
      )
    ))
    cloc
    difftastic
    dua
    entr
    hyperfine
    git-absorb
    graphviz-nox
    iterm2
    jless
    just
    mas
    micro
    fastfetch
    proselint
    shellcheck
    typos
    typos-lsp
    xmlformat
  ];
  fonts = with pkgs; [
    fira-mono
    inconsolata
    jetbrains-mono
    nanum-gothic-coding
    roboto-mono
    source-code-pro
    (pkgs.callPackage ../packages/dm-mono.nix { dm-mono-src = "${inputs.dm-mono-font}"; })
    monaspace
    nerd-fonts.iosevka
  ];
in
{
  imports = [
    ./fish.nix
    ./git.nix
    ./starship.nix
    ./vscode.nix
    ./zed.nix
  ];

  home.packages = nixPackages ++ networkingPackages ++ cmdLineUtilPackages ++ miscPackages ++ fonts;

  programs = {
    tmux = {
      enable = true;
      prefix = "C-a";
      clock24 = true;
      historyLimit = 100000000;
      mouse = true;
      shell = "/etc/profiles/per-user/abhinav/bin/fish";
      terminal = "tmux-256color";
      plugins = with pkgs; [ tmuxPlugins.better-mouse-mode ];
      extraConfig = ''
        set -g status off
      '';
    };

    htop = {
      enable = true;
      settings = {
        hide_kernel_threads = true;
        hide_threads = true;
        hide_userland_threads = true;
        highlight_base_name = true;
        show_program_path = false;
        sort_direction = false;
        sort_key = "PERCENT_CPU";
        tree_view = true;
      };
    };

    eza = {
      enable = true;
      git = true;
    };

    direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
    };

    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };

    bat = {
      enable = true;
      config = {
        italic-text = "always";
        paging = "always";
        tabs = "2";
        theme = "DarkNeon";
      };
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
      fileWidgetCommand = "fd --type f --no-ignore";
      historyWidgetOptions = [
        "--reverse"
        "--sort"
        "--exact"
      ];
    };

    micro = {
      enable = true;
      settings = {
        autoindent = true;
        colorcolumn = 100;
        colorscheme = "gruvbox";
        diffgutter = true;
        hlsearch = true;
        mkparents = true;
        savecursor = true;
        softwrap = true;
        tabsize = 2;
        tabstospaces = true;
        # plugins
        manipulator = true;
      };
    };

    zoxide.enable = true;

    ghostty = {
      enable = true;
      package = pkgs-ghostty.ghostty;
      enableFishIntegration = true;
      enableBashIntegration = true;
      installBatSyntax = false;
      settings = {
        background-opacity = 0.95;
        command = "/etc/profiles/per-user/abhinav/bin/tmux new";
        copy-on-select = true;
        font-family = "PragmataPro Mono";
        font-size = 14;
        macos-titlebar-style = "hidden";
        minimum-contrast = 1.05;
        mouse-hide-while-typing = true;
        quick-terminal-position = "right";
        quit-after-last-window-closed = false;
        scrollback-limit = 100000000;
        shell-integration = "detect";
        theme = "ayu";
        keybind = [
          "global:cmd+shift+a=toggle_quick_terminal"
        ];
      };
    };
  };
}
