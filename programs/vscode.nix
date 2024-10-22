{
  inputs,
  config,
  pkgs,
  ...
}:

let
  lib = pkgs.lib;
  extension = (
    inputs.nix-vscode-extensions.extensions.${pkgs.system}.forVSCodeVersion pkgs.vscode.version
  );
  marketplace-prerelease = extension.vscode-marketplace;
  marketplace-release = extension.vscode-marketplace-release;
  resolveExtension =
    ex:
    let
      exParts = lib.strings.splitString "." ex;
    in
    if lib.attrsets.hasAttrByPath exParts marketplace-release then
      lib.attrsets.getAttrFromPath exParts marketplace-release
    else
      lib.attrsets.getAttrFromPath exParts marketplace-prerelease;
in
{
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;

    extensions = builtins.map resolveExtension [
      "13xforever.language-x86-64-assembly"
      "bierner.markdown-mermaid"
      "cs128.cs128-clang-tidy"
      "davidanson.vscode-markdownlint"
      "dawhite.mustache"
      "donjayamanne.githistory"
      "dotjoshjohnson.xml"
      "esbenp.prettier-vscode"
      "golang.go"
      "haskell.haskell"
      "ivandemchenko.roc-lang-unofficial"
      "jdinhlife.gruvbox"
      "jebbs.plantuml"
      "jnoortheen.nix-ide"
      "justusadam.language-haskell"
      "kamikillerto.vscode-colorize"
      "kirozen.wordcounter"
      "llvm-vs-code-extensions.vscode-clangd"
      "mesonbuild.mesonbuild"
      "mkhl.direnv"
      "ms-python.black-formatter"
      "ms-python.debugpy"
      "ms-python.python"
      "ms-python.vscode-pylance"
      "pedrorgirardi.vscode-cljfmt"
      "rust-lang.rust-analyzer"
      "skellock.just"
      "streetsidesoftware.code-spell-checker"
      "tamasfe.even-better-toml"
      "timonwong.shellcheck"
      "twxs.cmake"
      "tyriar.sort-lines"
      "vadimcn.vscode-lldb"
      "viablelab.capitalize"
      "wmaurer.change-case"
      "zhuangtongfa.material-theme"
      "ziglang.vscode-zig"
    ];

    userSettings = {
      debug.console.fontSize = 13;
      diffEditor.ignoreTrimWhitespace = true;

      editor = {
        accessibilitySupport = "off";
        bracketPairColorization.enabled = true;
        folding = false;
        fontFamily = "'DM Mono', NanumGothicCoding, Menlo, Monaco, 'Courier New', monospace";
        fontLigatures = true;
        fontSize = 13;
        guides = {
          indentation = false;
          bracketPairs = true;
        };
        inlineSuggest.enabled = true;
        minimap.enabled = false;
        renderControlCharacters = true;
        renderWhitespace = "none";
        rulers = [ 100 ];
        tabSize = 2;
      };

      explorer.confirmDragAndDrop = false;
      extensions.ignoreRecommendations = false;

      files = {
        associations = {
          "*.co" = "javascript";
          "*.rkt" = "clojure";
          ".envrc*" = "shellscript";
        };
        autoSave = "afterDelay";
        autoSaveDelay = 60000;
        exclude = {
          "**/.git" = true;
          "**/.svn" = true;
          "**/.hg" = true;
          "**/CVS" = true;
          "**/.DS_Store" = true;
          "**/Thumbs.db" = true;
          "**/dist-newstyle" = true;
          "**/node_modules" = true;
          "**/.hie" = true;
          "**/.direnv" = true;
        };
        insertFinalNewline = true;
        trimFinalNewlines = true;
        trimTrailingWhitespace = true;
      };

      haskell = {
        manageHLS = "PATH";
        plugin.tactics.config.timeout_duration = 5;
      };

      roc-lang.language-server.exe = "/nix/store/1m7xfjx1b79s39cxl52aq77z22yffs4a-roc-0.0.1/bin/roc_language_server";

      nix = {
        formatterPath = "${pkgs.nixfmt}/bin/nixfmt";
        enableLanguageServer = true;
        serverPath = "nixd";
        serverSettings = {
          nixd = {
            formatting.command = [ "nixfmt" ];
          };
        };
      };

      oneDarkPro = {
        editorTheme = "Shadow";
        vivid = true;
      };

      spellright = {
        documentTypes = [
          "markdown"
          "latex"
        ];
        language = [ "en" ];
      };

      telemetry = {
        enableCrashReporter = false;
        enableTelemetry = false;
      };

      terminal.integrated = {
        copyOnSelection = true;
        fontFamily = "'DM Mono', NanumGothicCoding, Menlo, Monaco, 'Courier New', monospace";
        scrollback = 10000;
        shell.osx = "${pkgs.fish}/bin/fish";
        shellIntegration.enabled = true;
      };

      window.autoDetectColorScheme = true;

      workbench = {
        activityBar = {
          visible = false;
          location = "hidden";
        };
        colorTheme = "Gruvbox Dark Hard";
        editor.highlightModifiedTabs = true;
        preferredDarkColorTheme = "Gruvbox Dark Hard";
        startupEditor = "none";
      };

      update.mode = "none";

      "[haskell]" = {
        editor.defaultFormatter = "haskell.haskell";
      };
      "[javascript]" = {
        editor.defaultFormatter = "esbenp.prettier-vscode";
      };
      "[json]" = {
        editor.defaultFormatter = "esbenp.prettier-vscode";
      };
      "[python]" = {
        editor.defaultFormatter = "ms-python.black-formatter";
      };

      black-formatter.args = [
        "--line-length"
        "100"
      ];
    };

    keybindings = [
      {
        key = "ctrl+shift+up";
        command = "editor.action.insertCursorAbove";
        when = "editorTextFocus";
      }
      {
        key = "alt+cmd+up";
        command = "-editor.action.insertCursorAbove";
        when = "editorTextFocus";
      }
      {
        key = "ctrl+shift+down";
        command = "editor.action.insertCursorBelow";
        when = "editorTextFocus";
      }
      {
        key = "alt+cmd+down";
        command = "-editor.action.insertCursorBelow";
        when = "editorTextFocus";
      }
      {
        key = "ctrl+cmd+t";
        command = "terminal.focus";
      }
    ];
  };
}
