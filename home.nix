{ config, pkgs, ... }:

{
  home.username = "abhinav";
  home.homeDirectory = "/Users/abhinav";
  home.stateVersion = "22.05";
  home.enableNixpkgsReleaseCheck = true;

  home.shellAliases = {
    j = "just";
    g = "git";
    l = "bat";
    m = "micro";
    du = "dua interactive";
  };

  home.sessionVariables = { EDITOR = "micro"; };

  nixpkgs.config.allowUnfree = true;
  nix.package = pkgs.nixUnstable;
  nix.settings = {
    experimental-features = "nix-command flakes";
    max-jobs = 6;
    cores = 2;
    auto-optimise-store = true;
  };

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

  programs.fish = {
    enable = true;

    plugins = [
      {
        name = "foreign-env";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-foreign-env";
          rev = "b3dd471bcc885b597c3922e4de836e06415e52dd";
          sha256 = "00xqlyl3lffc5l0viin1nyp819wf81fncqyz87jx8ljjdhilmgbs";
        };
      }
      {
        name = "agnoster";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "theme-agnoster";
          rev = "43860ce1536930bca689470e26083b0a5b7bd6ae";
          sha256 = "16k94hz3s6wayass6g1lhlcjmbpf2w8mzx90qrrqp120h80xwp25";
        };
      }
      {
        name = "fzf";
        src = pkgs.fetchFromGitHub {
          owner = "PatrickF1";
          repo = "fzf.fish";
          rev = "2bb6f712b0b99fc5cc40ca78b6b3ba8b2529b0f7";
          hash = "sha256-XmRGe39O3xXmTvfawwT2mCwLIyXOlQm7f40mH5tzz+s=";
        };
      }
    ];
    interactiveShellInit = ''
      fzf_configure_bindings --git_status=\cs --history=\cr --variables=\cv --directory=\cf --git_log=\cg
    '';

    shellInit = ''
      # nix
      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        fenv source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      end

      # home-manager
      if test -e $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
        fenv source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
      end
    '';
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

  # Packages to install
  home.packages = with pkgs; [
    cloc
    cloudflare-dyndns
    config.nix.package
    coreutils
    delta
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
    (import ./dm-mono.nix { inherit lib fetchzip; })
  ];

  launchd.agents.dyndns-updater = {
    enable = true;
    config = {
      Program = "${pkgs.cloudflare-dyndns}/bin/cloudflare-dyndns";
      ProgramArguments = [
        "${pkgs.cloudflare-dyndns}/bin/cloudflare-dyndns"
        "--api-token"
        (builtins.readFile ./.cloudflare_dns_updater_api_token)
        "--debug"
        "home.abhinavsarkar.net"
      ];
      StandardErrorPath = "/tmp/cloudflare-dyndns.log";
      StandardOutPath = "/tmp/cloudflare-dyndns.log";
      StartInterval = 600;
      ProcessType = "Background";
    };
  };

}
