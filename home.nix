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

    shellAliases = {
      g = "${pkgs.git}/bin/git";
      j = "${pkgs.just}/bin/just";
      l = "${pkgs.bat}/bin/bat -n";
      m = "${pkgs.micro}/bin/micro";

      br = "${pkgs.broot}/bin/broot";
      du = "${pkgs.dua}/bin/dua interactive";
      tf = "${pkgs.coreutils-full}/bin/tail -f";
      cat = "${pkgs.bat}/bin/bat";
    };
  };
}
