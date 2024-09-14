{ pkgs, inputs, ... }: {
  imports = [ ./nix.nix ./system.nix ./services.nix ];
}
