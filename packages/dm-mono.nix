{ dm-mono-src, lib, pkgs }:

pkgs.linkFarm "dm-mono" [{
  name = "share/fonts/truetype";
  path = "${dm-mono-src}/exports";
}]
