{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Abhinav Sarkar";
    userEmail = "abhinav@abhinavsarkar.net";

    aliases = {
      a = "add";
      d = "diff";
      c = "commit";
      p = "push";
      s = "status";
      ui = "!gitui";
      ca = "commit --amend --no-edit";
      pf = "push --force-with-lease";
      lg =
        "log --graph --abbrev-commit --decorate --all --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'";
      uc = "reset --soft HEAD~1";
    };

    delta = {
      enable = true;
      options = {
        features = "decorations";
        navigate = true;
        line-numbers = true;
        syntax-theme = "Dracula";
        side-by-side = true;
        decorations = {
          commit-decoration-style = "blue ol";
          commit-style = "raw";
          file-style = "omit";
          hunk-header-decoration-style = "blue box";
          hunk-header-file-style = "red";
          hunk-header-line-number-style = "#067a00";
          hunk-header-style = "file line-number syntax";
        };
        interactive = { keep-plus-minus-markers = false; };
      };
    };

    extraConfig = {
      init.defaultBranch = "main";
      pull = {
        ff = "only";
        rebase = true;
      };
      merge.conflictstyle = "diff3";
    };

    ignores = [ "*.swp" "*~" "#*" ".DS_Store" ".direnv/" ".vscode/" ];
  };
}
