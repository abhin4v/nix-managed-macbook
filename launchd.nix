{ config, pkgs, lib, ... }:

let binDir = "${config.home.profileDirectory}/bin";
in {
  launchd.agents.dyndns-updater = lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
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
      StandardErrorPath = "/tmp/hm-dyndns-updater.log";
      StandardOutPath = "/tmp/hm-dyndns-updater.log";
      StartInterval = 600;
      ProcessType = "Background";
    };
  };

  launchd.agents.program-updater = lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
    enable = true;
    config = {
      Program = "${binDir}/bash";
      ProgramArguments = [
        "${binDir}/bash"
        "-c"
        ''echo && date && \
          export PATH="${binDir}:$PATH" && echo $PATH && \
          nix-channel --update && \
          home-manager switch && 
          nix-collect-garbage -d --delete-old
        ''
      ];
      StandardErrorPath = "/tmp/hm-program-updater.log";
      StandardOutPath = "/tmp/hm-program-updater.log";
      StartCalendarInterval = [{
        Hour = 10;
        Minute = 30;
      }];
      ProcessType = "Background";
    };
  };
}
