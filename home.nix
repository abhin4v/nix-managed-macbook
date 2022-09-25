{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "abhinav";
  home.homeDirectory = "/Users/abhinav";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
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

    shellAliases = {
      j = "just";
      g = "git";
    };

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
    ];
    interactiveShellInit = ''
      set EDITOR micro
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

    loginShellInit = ''
      fish_add_path --move --prepend --path $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /run/current-system/sw/bin /nix/var/nix/profiles/default/bin # https://github.com/LnL7/nix-darwin/issues/122
    '';
  };

  programs.micro = {
    enable = true;
    settings = {
      colorscheme = "gotham";
      tabsize = 2;
      tabstospaces = true;
      autoindent = true;
      colorcolumn = 100;
      diffgutter = true;
      hlsearch = true;
      mkparents = true;
      savecursor = true;
      manipulator = true;
    };
  };

  # Packages to install
  home.packages = with pkgs; [
    # pkgs is the set of all packages in the default home.nix implementation
    cloc
    cloudflare-dyndns
    coreutils
    delta
    entr
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
  ];

}
