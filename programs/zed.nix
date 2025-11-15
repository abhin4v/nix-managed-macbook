{
  inputs,
  config,
  pkgs,
  ...
}:

{
  programs.zed-editor = {
    enable = true;
    extraPackages = [ pkgs.harper ];
    extensions = [
      "catppuccin"
      "assembly"
      "brainfuck"
      "ini"
      "just"
      "nix"
      "haskell"
      "toml"
      "harper"
      "xml"
      "clojure"
      "mustache"
      "make"
    ];
    userSettings = {
      theme = "Gruvbox Dark Hard";
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      buffer_font_family = "PragmataPro Mono Liga"; # "Zed Plex Mono";
      ui_font_size = 16;
      buffer_font_size = 13;
      confirm_quit = true;
      cursor_blink = false;
      tab_size = 2;
      terminal = {
        font_family = ".ZedMono";
        shell = {
          program = "/etc/profiles/per-user/abhinav/bin/fish";
        };
        env = {
          EDITOR = "zed --wait";
        };
        copy_on_select = true;
      };
      indent_guides = {
        enabled = true;
        coloring = "indent_aware";
      };
      inlay_hints.enabled = true;
      wrap_guides = [
        80
        100
        120
      ];
      agent = {
        default_model = {
          provider = "ollama";
          model = "gemma3:latest";
        };
      };
      languages = {
        Haskell = {
          tab_size = 2;
          format_on_save = "on";
          preferred_line_length = 90;
          language_servers = [ "hls" ];
        };
        Nix = {
          tab_size = 2;
          format_on_save = "on";
          language_servers = [
            "nil"
            "nixd"
          ];
          formatter = {
            external = {
              command = "nixfmt";
              arguments = [
                "--filename"
                "{buffer_path}"
                "-s"
                "-w"
                "100"
              ];
            };
          };
        };
      };
      lsp = {
        hls = {
          initialization_options = {
            haskell = {
              formattingProvider = "ormolu";
              cabalFormattingProvider = "cabal-fmt";
              sessionLoading = "multipleComponents";
            };
          };
        };
        nix = { };
      };
    };
  };
}
