{ config, pkgs, ... }:

{
  imports = [ ./programs ./scripts ./launchd.nix ./nix.nix ];

  home = {
    username = "abhinav";
    homeDirectory = "/Users/abhinav";
    stateVersion = "22.05";
    enableNixpkgsReleaseCheck = true;

    shellAliases =
    let
      projectsDir = "${config.home.homeDirectory}/Projects";
      mm = "${projectsDir}/nix-managed-macbook";
      nv = "${projectsDir}/nixed-DO-VPS";
    in {
      g = "${pkgs.git}/bin/git";
      j = "${pkgs.just}/bin/just";
      l = "${pkgs.bat}/bin/bat";
      m = "${pkgs.micro}/bin/micro";

      br = "${pkgs.broot}/bin/broot";
      du = "${pkgs.dua}/bin/dua interactive";
      tf = "${pkgs.coreutils-full}/bin/tail -f";
      cat = "${pkgs.bat}/bin/bat";

      home-manager-switch = "just ${mm}/switch";
      home-manager-update = "just ${mm}/update";
      home-manager-clean = "just ${mm}/clean";
      vps-connect = "just ${nv}/connect";
      vps-upgrade = "just ${nv}/upgrade";
      deploy-website = "just ${nv}/run-service abhinavsarkar.net";
    };

    sessionVariables = { EDITOR = "micro"; };

    file."Applications/Home Manager Apps".source = let
      apps = pkgs.buildEnv {
        name = "home-manager-applications";
        paths = config.home.packages;
        pathsToLink = "/Applications";
      };
    in "${apps}/Applications";
  };
}
