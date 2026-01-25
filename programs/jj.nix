{ config, pkgs, ... }:

{
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Abhinav Sarkar";
        email = "abhinav@abhinavsarkar.net";
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
        tug = ["bookmark" "move" "--from" "heads(::@ & bookmarks())" "--to" "closest_pushable(@)"];
      };

      revset-aliases = {
        "default()" = "coalesce(trunk(),root())::present(@) | ancestors(visible_heads() & recent(), 5)";
        "recent()" = ''committer_date(after:"1 month ago")'';
        "closest_pushable(to)" = ''heads(::to & mutable() & ~description(exact:"") & (~empty() | merges()))'';
      };
    };
  };
}
