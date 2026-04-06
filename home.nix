{
  config,
  pkgs,
  lib,
  ...
}:

let
  username = config.home.username;
in
{
  imports = [
    ./programs
    ./scripts
    ./launchd.nix
  ];

  targets.darwin.linkApps.enable = true;

  home = {
    username = "abhinav";
    homeDirectory = lib.mkForce "/Users/${username}";
    stateVersion = "22.05";
    enableNixpkgsReleaseCheck = true;
  };
}
