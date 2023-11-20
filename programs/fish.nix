{ inputs, config, pkgs, ... }:

{
  programs.fish = {
    enable = true;

    plugins = [
      {
        name = "foreign-env";
        src = inputs.fish-plugin-foreign-env;
      }
      {
        name = "fzf";
        src = inputs.fish-plugin-fzf;
      }
    ];

    functions = {
      where = "readlink -f (which $argv)";
      ghe =
        "set -l dir (mktemp -d); git clone --depth 1 https://github.com/$argv $dir; cd $dir; ranger;";
    };

    interactiveShellInit = ''
      fzf_configure_bindings --git_status=\cs --history=\cr --variables=\cv --directory=\cf --git_log=\cg
      neofetch
    '';

    shellInit = ''
      # nix
      fenv source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      fish_add_path -m ~/.local/bin ~/.cabal/bin
    '';
  };
}
