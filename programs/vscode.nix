{ config, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;

    extensions = with pkgs.vscode-extensions;
      [
        bierner.markdown-mermaid
        bungcip.better-toml
        davidanson.vscode-markdownlint
        esbenp.prettier-vscode
        haskell.haskell
        jdinhlife.gruvbox
        jnoortheen.nix-ide
        justusadam.language-haskell
        kamikillerto.vscode-colorize
        matklad.rust-analyzer
        mhutchie.git-graph
        skellock.just
        streetsidesoftware.code-spell-checker
        timonwong.shellcheck
        tyriar.sort-lines
        zhuangtongfa.material-theme
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          publisher = "13xforever";
          name = "language-x86-64-assembly";
          version = "3.0.0";
          sha256 = "sha256-wIsY6Fuhs676EH8rSz4fTHemVhOe5Se9SY3Q9iAqr1M=";
        }
        {
          publisher = "ban";
          name = "spellright";
          version = "3.0.90";
          sha256 = "sha256-yAHlwX2stqGuUu3Q+mVxsF1JKmTgy/kkT63VH3YlomM=";
        }
        {
          publisher = "dawhite";
          name = "mustache";
          version = "1.1.1";
          sha256 = "sha256-PkymMex1icvDN2Df38EIuV1O9TkMNWP2sGOjl1+xGMk=";
        }
        {
          publisher = "jebbs";
          name = "plantuml";
          version = "2.17.4";
          sha256 = "sha256-fnz6ubB73i7rJcv+paYyNV1r4cReuyFPjgPM0HO40ug";
        }
        {
          publisher = "kirozen";
          name = "wordcounter";
          version = "2.4.3";
          sha256 = "sha256-gkdMaMiDwQNjmrGfUK/c/bQUn1bovESRPJ+etz2yfJk=";
        }
        {
          publisher = "pedrorgirardi";
          name = "vscode-cljfmt";
          version = "1.3.0";
          sha256 = "sha256-gZ8Fo7YXSapnQL6UbYUKJDg27wYqK2NG1lcJUae6dWs=";
        }
        {
          publisher = "wmaurer";
          name = "change-case";
          version = "1.0.0";
          sha256 = "sha256-tN/jlG2PzuiCeERpgQvdqDoa3UgrUaM7fKHv6KFqujc=";
        }
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
