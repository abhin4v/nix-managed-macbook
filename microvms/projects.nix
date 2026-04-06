{ lib, pkgs, ... }:
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
        size = 10240;
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
    interactiveShellInit = ''
      set -gx STARSHIP_CONFIG /etc/starship.toml
      starship init fish | source
    '';
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
  environment.enableAllTerminfo = true;
  environment.systemPackages = [ pkgs.micro pkgs.starship ]
    ++ (import ../programs/fish-plugins.nix { inherit pkgs; });
  environment.etc = let
    fishPlugins = import ../programs/fish-plugins.nix { inherit pkgs; };
    starshipSettings = import ../programs/starship-settings.nix { inherit lib; };
    starshipToml = (pkgs.formats.toml { }).generate "starship.toml" starshipSettings;
  in {
    "starship.toml".source = starshipToml;
  } // lib.listToAttrs (lib.concatMap (plugin:
    let name = plugin.pname or plugin.name or "fish-plugin"; in
    (lib.optional (builtins.pathExists "${plugin}/share/fish/vendor_conf.d") {
      name = "fish/conf.d/${name}.fish";
      value.source = "${plugin}/share/fish/vendor_conf.d/${builtins.head (builtins.attrNames (builtins.readDir "${plugin}/share/fish/vendor_conf.d"))}";
    })
    ++ (lib.optional (builtins.pathExists "${plugin}/share/fish/vendor_functions.d") {
      name = "fish/functions/${name}";
      value.source = "${plugin}/share/fish/vendor_functions.d";
    })
  ) fishPlugins);

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
  };
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.05";
}
