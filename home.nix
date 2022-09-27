{ config, pkgs, ... }:

{
  imports = [ ./programs ./launchd.nix ./nix.nix ];

  home.username = "abhinav";
  home.homeDirectory = "/Users/abhinav";
  home.stateVersion = "22.05";
  home.enableNixpkgsReleaseCheck = true;

  home.shellAliases = {
    j = "just";
    g = "git";
    l = "bat";
    m = "micro";
    du = "dua interactive";
    br = "broot";
  };

  home.sessionVariables = { EDITOR = "micro"; };
}
