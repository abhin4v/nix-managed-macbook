{
  config,
  pkgs,
  lib,
  ...
}:

let
  cloudflare = pkgs.python3.pkgs.cloudflare.overrideAttrs (oldAttrs: {
    patches = [ ./packages/python-cloudflare/hatchling.patch ];
  });
  pkg = (pkgs.cloudflare-dyndns).overridePythonAttrs (old: {
    dependencies = (lib.lists.remove pkgs.python3.pkgs.cloudflare old.dependencies) ++ [
      cloudflare
    ];
  });
  # pkgs = pkgs-python-cloudflare-4_0_0;
  binPath = "${pkgs.coreutils-full}/bin";
  dyndns-updater-script = pkgs.writeScript "dyndns-updater" ''
    #!${pkgs.bash}/bin/bash
    export CLOUDFLARE_API_TOKEN=`${binPath}/cat ${config.xdg.configHome}/.cloudflare_dns_updater_api_token`
    ${binPath}/echo && ${binPath}/date
    ${pkg}/bin/cloudflare-dyndns --debug home.abhinavsarkar.net
  '';
in
{
  launchd.agents.dyndns-updater = lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
    enable = true;
    config = {
      Program = "${dyndns-updater-script}";
      StandardErrorPath = "/tmp/hm-dyndns-updater.log";
      StandardOutPath = "/tmp/hm-dyndns-updater.log";
      StartInterval = 600;
      ProcessType = "Background";
    };
  };
}
