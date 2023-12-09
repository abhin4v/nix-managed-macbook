{ config, pkgs, ... }:

let
  profiles = "/nix/var/nix/profiles/per-user/${config.home.username}/profile-*-link";
in
pkgs.writeShellScriptBin "report-hm-changes" ''
  # Disable nvd if there are less than 2 hm profiles.
  if [ $(/bin/ls -d1v ${profiles} 2>/dev/null | wc -l) -lt 2 ]; then
    echo "Skipping changes report..."
  else
    ${pkgs.nvd}/bin/nvd diff $(/bin/ls -d1v ${profiles} | tail -2)
  fi
''
