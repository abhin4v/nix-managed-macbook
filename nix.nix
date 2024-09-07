{ config, pkgs, inputs, ... }: {
  services.nix-daemon.enable = true;
  nix = {
    package = pkgs.nixFlakes;
    registry.nixpkgs.flake = inputs.nixpkgs;
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
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
    settings = {
      auto-optimise-store = true;
      connect-timeout = 60;
      download-attempts = 10;
      cores = 2;
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
      fallback = true;
      keep-outputs = true;
      keep-going = true;
      log-lines = 25;
      max-free = 1000000000;
      max-jobs = 6;
      min-free = 128000000;
      warn-dirty = false;
      trusted-users = [ "@admin" ];
    };
  };
  nixpkgs = {
    hostPlatform = "x86_64-darwin";
    config.allowUnfree = true;
  };
}
