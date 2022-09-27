{ lib, fetchzip }:

let
  pname = "dm-mono";
  version = "1.0.0";
in fetchzip {
  name = "${pname}-${version}";
  extension = "zip";
  stripRoot = false;

  url = "https://fonts.google.com/download?family=DM%20Mono";
  hash = "sha256-HAStsW+SAAkOjywPBSzhmib+fEylWZo6PtNtfDVNYZ0=";

  postFetch = ''
    mkdir -p $out/share/fonts/truetype
    mv $out/*.ttf $out/share/fonts/truetype
  '';

  meta = with lib; {
    description = "DM Mono";
    homepage = "https://github.com/googlefonts/dm-mono";
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
