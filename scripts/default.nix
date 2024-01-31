{ config, lib, pkgs, ... }:

let rc = pkgs.callPackage ./report-hm-changes.nix { inherit config pkgs; };
in { home.packages = [ rc ]; }
