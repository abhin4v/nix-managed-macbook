{ pkgs, ... }:

let
  fishPlugins = import ./fish-plugins.nix { inherit pkgs; };
in
{
  imports = [
    ./git.nix
    ./jj.nix
    ./starship.nix
  ];

  home.packages = with pkgs; [
    amp-cli
    as-tree
    bash
    broot
    cloc
    coreutils-full
    curl
    difftastic
    dua
    entr
    fd
    git-absorb
    gnugrep
    httpie
    hyperfine
    jjui
    just
    less
    nix-output-monitor
    nixd
    opencode
    tree
    unixtools.watch
    xmlformat
  ];

  home.shellAliases = {
    g = "${pkgs.git}/bin/git";
    j = "${pkgs.just}/bin/just";
    l = "${pkgs.bat}/bin/bat -n";
    m = "${pkgs.micro}/bin/micro";

    br = "${pkgs.broot}/bin/broot";
    du = "${pkgs.dua}/bin/dua interactive";
    tf = "${pkgs.coreutils-full}/bin/tail -f";
    cat = "${pkgs.bat}/bin/bat";
  };

  programs.fish = {
    enable = true;
    plugins = builtins.map (p: {
      name = p.meta.name;
      src = p.src;
    }) fishPlugins;
  };

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
    git = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
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
    historyWidgetOptions = [
      "--reverse"
      "--sort"
      "--exact"
    ];
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
      manipulator = true;
    };
  };

  programs.zoxide.enable = true;
}
