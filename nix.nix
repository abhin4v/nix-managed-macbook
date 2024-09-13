{ config, pkgs, inputs, ... }:
let
  nixSettings = {
    auto-optimise-store = true;
    connect-timeout = 60;
    download-attempts = 10;
    cores = 4;
    experimental-features = [ "nix-command" "flakes" "repl-flake" ];
    fallback = true;
    keep-outputs = true;
    keep-going = true;
    log-lines = 25;
    max-jobs = 3;
  };
in {
  services.nix-daemon.enable = true;
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
    gc = {
      automatic = true;
      interval = {
        Hour = 18;
        Minute = 15;
      };
      options = "-d --delete-older-than 7d";
    };
    settings = nixSettings // {
      max-free = 1000000000;
      min-free = 128000000;
      warn-dirty = false;
      trusted-users = [ "@admin" ];
    };
    distributedBuilds = true;
    linux-builder = {
      enable = true;
      maxJobs = 3;
      config = ({ pkgs, ... }: {
        users.extraGroups.docker.members =
          builtins.map (i: "nixbld" + builtins.toString i)
          (pkgs.lib.genList (i: i + 1) 32);
        virtualisation = {
          docker.enable = true;
          darwin-builder = {
            diskSize = 40 * 1024;
            memorySize = 8 * 1024;
          };
          cores = 4;
        };
        nix.settings = nixSettings // { sandbox = false; };
      });
    };
  };
  nixpkgs = {
    hostPlatform = "x86_64-darwin";
    config.allowUnfree = true;
  };
}
