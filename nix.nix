{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  nix.package = pkgs.nixStable;
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" "repl-flake" ];
    max-jobs = 6;
    cores = 2;
    auto-optimise-store = true;
    connect-timeout = 5;
    log-lines = 25;
    min-free = 128000000;
    max-free = 1000000000;
    fallback = true;
    warn-dirty = false;
    keep-outputs = true;
  };
}
