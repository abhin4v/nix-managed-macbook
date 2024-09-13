{ ... }: {
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      cleanup = "uninstall";
      upgrade = false;
    };
    global = {
      autoUpdate = false;
      brewfile = true;
    };
    casks = [
      "amethyst"
      "appcleaner"
      "calibre"
      "dropbox"
      "fanny"
      "firefox"
      "garmin-express"
      "google-chrome"
      "homebrew/cask/handbrake"
      "lastfm"
      "monodraw"
      "obsidian"
      "spotify"
      "steam"
      "telegram"
      "utm"
      "vlc"
    ];
    masApps = {
      Amphetamine = 937984704;
      Bear = 1091189122;
      iMovie = 408981434;
      Ivory = 6444602274;
      Keynote = 409183694;
      Kindle = 302584613;
      NextDNS = 1464122853;
      Numbers = 409203825;
      Pages = 409201541;
      Reeder = 1449412482;
      TestFlight = 899247664;
      Xcode = 497799835;
    };
  };
}
