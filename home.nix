{ config, pkgs, ... }:

{
  imports = [ ./programs ./scripts ./launchd.nix ./nix.nix ];

  home = {
    username = "abhinav";
    homeDirectory = "/Users/abhinav";
    stateVersion = "22.05";
    enableNixpkgsReleaseCheck = true;

    shellAliases = {
      g = "${pkgs.git}/bin/git";
      j = "${pkgs.just}/bin/just";
      l = "${pkgs.bat}/bin/bat";
      m = "${pkgs.micro}/bin/micro";

      br = "${pkgs.broot}/bin/broot";
      du = "${pkgs.dua}/bin/dua interactive";
      tf = "${pkgs.coreutils-full}/bin/tail -f";
      cat = "${pkgs.bat}/bin/bat";
    };

    sessionVariables = {
      EDITOR = "micro";
      NIX_PATH = "$HOME/.hm-nixchannels";
    };

    file."Applications/Home Manager Apps".source = let
      apps = pkgs.buildEnv {
        name = "home-manager-applications";
        paths = config.home.packages;
        pathsToLink = "/Applications";
      };
    in "${apps}/Applications";
  };
}
