{ config, pkgs, ... }:

{
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Abhinav Sarkar";
        email = "abhinav@abhinavsarkar.net";
      };

      git = {
        push-new-bookmarks = true;
      };

      ui = {
        default-command = "log-recent";
        diff-formatter = "difft";
      };

      aliases = {
        log-recent = [
          "log"
          "-r"
          "default() & recent()"
        ];
      };

      revset-aliases = {
        "default()" = "coalesce(trunk(),root())::present(@) | ancestors(visible_heads() & recent(), 5)";
        "recent()" = ''committer_date(after:"1 month ago")'';
      };
    };
  };
}
