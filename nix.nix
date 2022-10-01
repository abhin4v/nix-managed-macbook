{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  nix.package = pkgs.nixUnstable;
  nix.settings = {
    experimental-features = "nix-command flakes repl-flake";
    max-jobs = 6;
    cores = 2;
    auto-optimise-store = true;
  };
}
