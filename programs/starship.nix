{
  config,
  pkgs,
  lib,
  ...
}:

let
  langs = [
    "c"
    "golang"
    "haskell"
    "java"
    "kotlin"
    "nodejs"
    "python"
    "perl"
    "ruby"
    "rust"
    "zig"
  ];
in
{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = builtins.foldl' lib.attrsets.recursiveUpdate { } [
      {
        add_newline = false;
        format =
          "$directory$username$hostname$localip$shlvl$git_branch$git_commit$git_state$git_metrics$git_status$package"
          + lib.strings.concatMapStrings (l: "\$${l}") langs
          + "$nix_shell$memory_usage$env_var$custom$sudo$cmd_duration$fill$jobs$battery$time$line_break$character";

        directory.fish_style_pwd_dir_length = 1;
        memory_usage.disabled = false;
        time.disabled = false;
        git_status = {
          conflicted = "=";
          ahead = "^";
          behind = "v";
          diverged = "≠";
          up_to_date = "";
          untracked = "?";
          stashed = "\$";
          modified = "!";
          staged = "+";
          renamed = "»";
          deleted = "✘";
        };

        cmd_duration.format = "\\[[$duration](yellow)\\]";
        git_branch.format = "\\[[$symbol$branch]($style)\\]";
        git_status.format = "([\\[$all_status$ahead_behind\\]]($style))";
        memory_usage.format = "\\[$symbol[$ram(|$swap)]($style)\\]";
        nix_shell.format = "\\[[$symbol$state( \\($name\\))]($style)\\]";
        package.format = "\\[[$symbol$version]($style)\\]";
        sudo.format = "\\[[as $symbol]\\]";
        time.format = "\\[[$time]($style)\\]";
        username.format = "\\[[$user]($style)\\]";

        c.symbol = "C ";
        directory.read_only = " ro";
        fill.symbol = " ";
        git_branch.symbol = "git ";
        golang.symbol = "go ";
        java.symbol = "java ";
        kotlin.symbol = "kt ";
        nodejs.symbol = "node ";
        memory_usage.symbol = "mem ";
        nix_shell.symbol = "nix ";
        package.symbol = "pkg ";
        perl.symbol = "pl ";
        python.symbol = "py ";
        ruby.symbol = "rb ";
        rust.symbol = "rs ";
        sudo.symbol = "sudo ";
        zig.symbol = "zig ";
      }
      (lib.attrsets.foldAttrs (i: _: i) [ ] (
        builtins.map (s: {
          "${s}" = {
            "version_format" = "\${raw}";
            "format" = "\\[[$symbol($version)]($style)\\]";
          };
        }) langs
      ))
      {
        c.format = "\\[[$symbol($version(-$name))]($style)\\]";
        python.format = "\\[[\${symbol}\${pyenv_prefix}(\${version})(\\($virtualenv\\))]($style)\\]";
      }
    ];
  };
}
