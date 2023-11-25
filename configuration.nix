{ pkgs, inputs, ... }:
{
  imports = [./nix.nix];
  security.pam.enableSudoTouchIdAuth = true;
  system = {
    defaults = {
      dock = {
        appswitcher-all-displays = false;
        autohide = true;
        magnification = true;
        mru-spaces = false;
        orientation = "bottom";
        wvous-bl-corner = 13;
        wvous-br-corner = 14;
        wvous-tl-corner = 2;
        wvous-tr-corner = 3;
      };
      finder = {
        AppleShowAllExtensions = true;
        FXPreferredViewStyle = "Nlsv";
      };
      NSGlobalDomain = {
        AppleEnableMouseSwipeNavigateWithScrolls = true;
        AppleEnableSwipeNavigateWithScrolls = true;
        AppleICUForce24HourTime = true;
        AppleInterfaceStyle = "Dark";
        AppleInterfaceStyleSwitchesAutomatically = false;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = true;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = true;
        _HIHideMenuBar = true;
      };
      trackpad = {
        Clicking = true;
        TrackpadRightClick = true;
      };
    };
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
    stateVersion = 4;
  };
}
