{
  inputs,
  config,
  pkgs,
  ...
}:

{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "assembly"
      "brainfuck"
      "ini"
      "just"
      "nix"
      "roc"
      "haskell"
      "toml"
      "typos"
    ];
    userSettings = {
      theme = "Gruvbox Dark Hard";
      telemetry = {
        diagnostic = false;
        metrics = false;
      };
      buffer_font_family = "PragmataPro Mono Liga"; # "Zed Plex Mono";
      ui_font_size = 16;
      buffer_font_size = 13;
      confirm_quit = true;
      cursor_blink = false;
      tab_size = 2;
      terminal = {
        font_family = "Zed Plex Mono";
        shell = {
          program = "/etc/profiles/per-user/abhinav/bin/fish";
        };
        copy_on_select = true;
      };
      indent_guides = {
        enabled = true;
        coloring = "indent_aware";
      };
      wrap_guides = [ 80 100 120 ];
      assistant = {
        default_model = {
          provider = "ollama";
          model = "gemma3:latest";
        };
        version = "2";
      };
      languages = {
        Haskell = {
          tab_size = 2;
          format_on_save = "on";
        };
        Nix = {
          tab_size = 2;
        };
      };
      lsp = {
        hls = {
          initialization_options = {
            sessionLoading = "multiComponent";
          };
        };
        nixd = {
          formatting = {
            command = [
              "nixfmt"
              "-s"
              "-w"
              "100"
            ];
          };
        };
      };
    };
  };
}
