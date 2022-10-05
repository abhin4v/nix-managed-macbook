{ inputs, config, pkgs, ... }:

{
  imports = [ ./fish.nix ./git.nix ./starship.nix ./vscode.nix ];

  home.packages = with pkgs; [
    bash
    broot
    cloc
    cloudflare-dyndns
    comma
    config.nix.package
    coreutils-full
    ddgr
    dua
    entr
    fd
    gitui
    graphviz-nox
    haskellPackages.cabal-plan
    haskellPackages.graphmod
    httpie
    jetbrains.idea-community
    micro
    neofetch
    niv
    nix
    nix-diff
    nixfmt
    proselint
    ranger
    rnix-lsp
    shellcheck
    spotify-tui
    statix
    tealdeer
    thefuck

    # fonts
    fira-mono
    inconsolata
    jetbrains-mono
    nanum-gothic-coding
    roboto-mono
    source-code-pro
    (import ../packages/dm-mono.nix { inherit lib pkgs; dm-mono-src = "${inputs.dm-mono-font}"; })
    (nerdfonts.override { fonts = [ "Monoid" "Agave" "Iosevka" "Lekton" "VictorMono" ]; })
  ];

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

  programs.exa = {
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

  programs.just = {
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
      colorscheme = "gotham";
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
}
