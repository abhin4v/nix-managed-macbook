{
  config,
  pkgs,
  inputs,
  ...
}:
let
  nixSettings = {
    connect-timeout = 60;
    download-attempts = 10;
    cores = 4;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    fallback = true;
    keep-outputs = true;
    keep-going = true;
    log-lines = 25;
    max-jobs = 5;
  };
in
{
  ids.gids.nixbld = 350;
  nix = {
    enable = true;
    package = pkgs.lix;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
    optimise.automatic = true;
    settings = nixSettings // {
      max-free = 1000000000;
      min-free = 128000000;
      warn-dirty = false;
      trusted-users = [ "@admin" ];
      trusted-substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://cache.lix.systems"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
      ];
    };
    distributedBuilds = true;
    linux-builder = {
      enable = true;
      package = pkgs.darwin.linux-builder-x86_64;
      systems = [ "x86_64-linux" ];
      ephemeral = true;
      maxJobs = 5;
      config = (
        { pkgs, ... }:
        {
          users.extraGroups.docker.members = builtins.map (i: "nixbld" + builtins.toString i) (
            pkgs.lib.genList (i: i + 1) 32
          );
          virtualisation = {
            docker.enable = true;
            darwin-builder = {
              diskSize = 50 * 1024;
              memorySize = 8 * 1024;
            };
            cores = 8;
          };
          nix.package = pkgs.lix;
          nix.settings = nixSettings // {
            sandbox = false;
            trusted-users = [ "builder" ];
          };
          nixpkgs.config.allowUnfree = true;
          environment.systemPackages = [ pkgs.htop ];
        }
      );
    };
  };
  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config.allowUnfree = true;
  };
}
