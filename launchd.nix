{ config, pkgs, ... }:

{
  launchd.agents.dyndns-updater = {
    enable = true;
    config = {
      Program = "${pkgs.cloudflare-dyndns}/bin/cloudflare-dyndns";
      ProgramArguments = [
        "${pkgs.cloudflare-dyndns}/bin/cloudflare-dyndns"
        "--api-token"
        (builtins.readFile ./.cloudflare_dns_updater_api_token)
        "--debug"
        "home.abhinavsarkar.net"
      ];
      StandardErrorPath = "/tmp/cloudflare-dyndns.log";
      StandardOutPath = "/tmp/cloudflare-dyndns.log";
      StartInterval = 600;
      ProcessType = "Background";
    };
  };
}
