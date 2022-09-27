{ config, pkgs, ... }:

{
  imports = [ ./fish.nix ];

  home.packages = with pkgs; [
    broot
    cloc
    cloudflare-dyndns
    config.nix.package
    coreutils
    delta
    dua
    entr
    fd
    gitui
    graphviz-nox
    haskellPackages.cabal-plan
    haskellPackages.graphmod
    httpie
    mosh
    micro
    niv
    nixfmt
    statix
    tree

    # fonts
    fira-mono
    inconsolata
    jetbrains-mono
    nanum-gothic-coding
    roboto-mono
    source-code-pro
    (import ../packages/dm-mono.nix { inherit lib fetchzip; })
  ];

  programs.home-manager.enable = true;

  programs.htop = {
    enable = true;
    settings = {
      hide_kernel_threads = true;
      hide_threads = true;
      hide_userland_threads = true;
      highlight_base_name = true;
      show_program_path = false;
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
