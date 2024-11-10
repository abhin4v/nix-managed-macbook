{
  config,
  pkgs,
  inputs,
  ...
}:
let
  nixSettings = {
    auto-optimise-store = true;
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
    max-jobs = 3;
  };
in
{
  services.nix-daemon.enable = true;
  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
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
      maxJobs = 3;
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
          nix.settings = nixSettings // {
            sandbox = false;
          };
        }
      );
    };
  };
  nixpkgs = {
    hostPlatform = "x86_64-darwin";
    config.allowUnfree = true;
  };
}
