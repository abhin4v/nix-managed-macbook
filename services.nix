{ config, pkgs, lib, ... }:
{
  services = {
    jankyborders = {
      enable = true;
      active_color = "0xff00ff00";
      hidpi = true;
    };
  };
}
