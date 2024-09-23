{ inputs, config, pkgs, ... }:

let
  nixPackages = with pkgs; [
    config.nix.package
    niv
    nix
    nix-diff
    nix-tree
    nixfmt
    nvd
    nixd
    statix
    cachix
    nix-output-monitor
  ];
  networkingPackages = with pkgs; [ curl dig httpie openssh mosh ];
  cmdLineUtilPackages = with pkgs; [ bash broot coreutils-full fd gnugrep less ranger tree unixtools.watch ];
  miscPackages = with pkgs; [
    binutils
    brotli
    cabal2nix
    cloc
    comma
    difftastic
    dua
    entr
    hyperfine
    git-absorb
    graphviz-nox
    iterm2
    jetbrains.idea-community
    just
    micro
    fastfetch
    proselint
    shellcheck
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
    (pkgs.callPackage ../packages/monaspace.nix { monaspace-src = "${inputs.monaspace-font}"; })
    (nerdfonts.override { fonts = [ "Monoid" "Agave" "Iosevka" "Lekton" "VictorMono" ]; })
  ];
in {
  imports = [ ./fish.nix ./git.nix ./starship.nix ./vscode.nix ];

  home.packages = nixPackages ++ networkingPackages ++ cmdLineUtilPackages ++ miscPackages ++ fonts;

  programs = {
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
      nix-direnv = { enable = true; };
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
      historyWidgetOptions = [ "--reverse" "--sort" "--exact" ];
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
  };
}
