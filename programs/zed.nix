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
      # themes
      "catppuccin"
      #languages
      "assembly"
      "brainfuck"
      "ini"
      "just"
      "nix"
      "haskell"
      "toml"
      "codebook"
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
      wrap_guides = [ 80 100 120 ];
      agent = {
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
          language_servers = [ "nil" "nixd" ];
          format_on_save = {
            external = {
              command = "nixfmt";
              arguments = [
                "--filename"
                "{buffer_path}"
                "-s"
                "-w"
                "1000"
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
        nix = {
          binary = {
            path_lookup = true;
          };
        };
      };
    };
  };
}
