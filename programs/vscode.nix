{ config, pkgs, ... }:

let
  marketplaceExtensions = [
    "13xforever/language-x86-64-assembly"
    "ban/spellright"
    "dawhite/mustache"
    "kirozen/wordcounter"
    "pedrorgirardi/vscode-cljfmt"
    "wmaurer/change-case"
  ];
in {
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;

    extensions = with pkgs.vscode-extensions;
      [
        bierner.markdown-mermaid
        bungcip.better-toml
        davidanson.vscode-markdownlint
        dotjoshjohnson.xml
        esbenp.prettier-vscode
        github.copilot
        haskell.haskell
        jdinhlife.gruvbox
        jebbs.plantuml
        jnoortheen.nix-ide
        justusadam.language-haskell
        kamikillerto.vscode-colorize
        mhutchie.git-graph
        rust-lang.rust-analyzer
        skellock.just
        streetsidesoftware.code-spell-checker
        timonwong.shellcheck
        tyriar.sort-lines
        zhuangtongfa.material-theme
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace (builtins.filter
        ({ publisher, name, ... }: builtins.elem (publisher + "/" + name) marketplaceExtensions)
        (import ./vscode/extensions.nix).extensions);

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
        guides.indentation = false;
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
        autoSaveDelay = 5000;
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

      nix = {
        enableLanguageServer = true;
        formatterPath = "${pkgs.nixfmt}/bin/nixfmt";
        serverPath = "${pkgs.rnix-lsp}/bin/rnix-lsp";
      };

      oneDarkPro = {
        editorTheme = "Shadow";
        vivid = true;
      };

      spellright = {
        documentTypes = [ "markdown" "latex" ];
        language = [ "en" ];
      };

      github.copilot.enable = {
        "*" = true;
        yaml = false;
        plaintext = false;
        markdown = true;
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
        activityBar.visible = false;
        colorTheme = "Gruvbox Dark Hard";
        editor.highlightModifiedTabs = true;
        preferredDarkColorTheme = "Gruvbox Dark Hard";
        startupEditor = "none";
      };

      update.mode = "none";

      "[haskell]" = { editor.defaultFormatter = "haskell.haskell"; };
      "[javascript]" = { editor.defaultFormatter = "esbenp.prettier-vscode"; };
      "[json]" = { editor.defaultFormatter = "esbenp.prettier-vscode"; };
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
