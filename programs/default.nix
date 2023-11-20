{ inputs, config, pkgs, ... }:

let
  nixPackages = with pkgs; [
    config.nix.package
    niv
    nix
    nix-diff
    nix-tree
    nixfmt
    rnix-lsp
    statix
    cachix
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
    gnugrep
    less
    ranger
    tree
  ];
  miscPackages = with pkgs; [
    cabal2nix
    cloc
    comma
    dua
    entr
    gitui
    graphviz-nox
    iterm2
    jetbrains.idea-community
    just
    micro
    neofetch
    proselint
    shellcheck
    toot
    typos
  ];
  fonts = with pkgs; [
    fira-mono
    inconsolata
    jetbrains-mono
    nanum-gothic-coding
    roboto-mono
    source-code-pro
    (pkgs.callPackage ../packages/dm-mono.nix { dm-mono-src = "${inputs.dm-mono-font}"; })
    (nerdfonts.override { fonts = [ "Monoid" "Agave" "Iosevka" "Lekton" "VictorMono" ]; })
  ];
in {
  imports = [ ./fish.nix ./git.nix ./starship.nix ./vscode.nix ];

  home.packages = nixPackages ++ networkingPackages ++ cmdLineUtilPackages ++ miscPackages ++ fonts;

  programs.htop = {
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

  programs.eza = {
    enable = true;
    enableAliases = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv = { enable = true; };
  };

  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.bat = {
    enable = true;
    config = {
      italic-text = "always";
      paging = "always";
      tabs = "2";
      theme = "DarkNeon";
    };
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    fileWidgetCommand = "fd --type f --no-ignore";
    historyWidgetOptions = [ "--reverse" "--sort" "--exact" ];
  };

  programs.micro = {
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

  programs.zoxide.enable = true;
}
