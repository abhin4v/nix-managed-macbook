{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  networking.hostName = "projects-microvm";
  services.getty.autologinUser = "root";
  microvm = {
    hypervisor = "vfkit";
    vcpu = 4;
    mem = 4096;
    writableStoreOverlay = "/nix/.rw-store";
    volumes = [
      {
        image = "nix-store-overlay.img";
        mountPoint = "/nix/.rw-store";
        size = 20480;
      }
    ];
    shares = [
      {
        proto = "virtiofs";
        tag = "ro-store";
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
      }
      {
        proto = "virtiofs";
        tag = "projects";
        source = "/Users/abhinav/Projects";
        mountPoint = "/projects";
      }
    ];
    interfaces = [
      {
        type = "user";
        id = "usernet";
        mac = "02:00:00:01:01:01";
      }
    ];
  };

  networking.interfaces.eth0.useDHCP = true;

  programs.fish = {
    enable = true;
    loginShellInit = ''
      set -gx TERM screen-256color
      if not set -q TMUX
        tmux new-session -A -s main
      end
    '';
    vendor.config.enable = true;
  };
  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    extraConfig = ''
      set -ga terminal-overrides ",screen-256color:Tc"
    '';
  };

  users.users.root.shell = pkgs.fish;

  nix = {
    settings = {
      connect-timeout = 60;
      download-attempts = 10;
      cores = 4;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      fallback = true;
    };
    registry.nixpkgs.flake = inputs.nixpkgs;
  };
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.05";
}
