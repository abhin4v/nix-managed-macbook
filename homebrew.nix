{ ... }:
{
  environment = {
    variables = {
      HOMEBREW_NO_ANALYTICS = "1";
      HOMEBREW_NO_INSECURE_REDIRECT = "1";
      HOMEBREW_NO_EMOJI = "1";
      HOMEBREW_NO_ENV_HINTS = "0";
    };
  };
  homebrew = {
    enable = true;
    caskArgs.require_sha = true;
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
      "firefox"
      {
        name = "librewolf";
        args = {
          no_quarantine = true;
        };
      }
      "google-chrome"
      "monodraw"
      "nextcloud"
      "signal"
      "spotify"
      # "steam"
      "telegram"
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
      ReadKit = 1615798039;
      TestFlight = 899247664;
      Xcode = 497799835;
    };
  };
}
