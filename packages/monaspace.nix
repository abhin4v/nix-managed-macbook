{
  monaspace-src,
  lib,
  pkgs,
}:

pkgs.linkFarm "monaspace" [
  {
    name = "share/fonts/truetype";
    path = "${monaspace-src}/fonts/variable";
  }
]
