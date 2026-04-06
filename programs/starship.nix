{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = import ./starship-settings.nix { inherit lib; };
  };
}
