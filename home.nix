{ config, pkgs, ... }:

{
  imports = [ ./programs ./launchd.nix ./nix.nix ];

  home.username = "abhinav";
  home.homeDirectory = "/Users/abhinav";
  home.stateVersion = "22.05";
  home.enableNixpkgsReleaseCheck = true;

  home.shellAliases = {
    g = "${pkgs.git}/bin/git";
    j = "${pkgs.just}/bin/just";
    l = "${pkgs.bat}/bin/bat";
    m = "${pkgs.micro}/bin/micro";

    br = "${pkgs.broot}/bin/broot";
    du = "${pkgs.dua}/bin/dua interactive";
    tf = "${pkgs.coreutils-full}/bin/tail -f";
    cat = "bat";
  };

  home.sessionVariables = { EDITOR = "micro"; };

  home.file."Applications/Home Manager Apps".source = let
    apps = pkgs.buildEnv {
      name = "home-manager-applications";
      paths = config.home.packages;
      pathsToLink = "/Applications";
    };
  in "${apps}/Applications";
}
