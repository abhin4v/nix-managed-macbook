{ config, pkgs, ... }:

{
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
        name = "fzf";
        src = pkgs.fetchFromGitHub {
          owner = "PatrickF1";
          repo = "fzf.fish";
          rev = "2bb6f712b0b99fc5cc40ca78b6b3ba8b2529b0f7";
          hash = "sha256-XmRGe39O3xXmTvfawwT2mCwLIyXOlQm7f40mH5tzz+s=";
        };
      }
    ];

    functions = {
      where = "readlink -f (which $argv)";
      ghe =
        "set -l dir (mktemp -d); git clone --depth 1 https://github.com/$argv $dir; cd $dir; ranger;";
    };

    interactiveShellInit = ''
      fzf_configure_bindings --git_status=\cs --history=\cr --variables=\cv --directory=\cf --git_log=\cg
      thefuck --alias f | source
      neofetch
    '';

    shellInit = ''
      # nix
      fenv source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    '';
  };
}
