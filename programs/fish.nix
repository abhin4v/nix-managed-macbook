{ inputs, config, osConfig, pkgs, ... }:

let username = config.home.username;
in {
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

      if test -d (brew --prefix)"/share/fish/completions"
        set -p fish_complete_path (brew --prefix)/share/fish/completions
      end

      if test -d (brew --prefix)"/share/fish/vendor_completions.d"
        set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
      end

      fastfetch
    '';

    shellInit = ''
      # nix
      fenv source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      fenv source /run/current-system/etc/bashrc
      fenv source /etc/profiles/per-user/${username}/etc/profile.d/hm-session-vars.sh
      fish_add_path -m ~/.local/bin ~/.cabal/bin /etc/profiles/per-user/${username}/bin
      eval "$(${osConfig.homebrew.brewPrefix}/brew shellenv)"
    '';
  };
}
