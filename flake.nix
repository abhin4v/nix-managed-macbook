{
  description = "Home Manager configuration of Abhinav Sarkar";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?rev=b200e0df08f80c32974a6108ce431d8a8a5e6547";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    dm-mono-font = {
      url = "github:googlefonts/dm-mono";
      flake = false;
    };
    fish-plugin-foreign-env = {
      url = "github:oh-my-fish/plugin-foreign-env";
      flake = false;
    };
    fish-plugin-fzf = {
      url = "github:PatrickF1/fzf.fish";
      flake = false;
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }:
    let
      system = "x86_64-darwin";
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };
    in {
      homeConfigurations.abhinav = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
        extraSpecialArgs = { inherit inputs; };
      };
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [ (import home-manager { inherit pkgs; }).home-manager just ];
        shellHook = ''
          export NIXPKGS_PATH=${pkgs.path};
        '';
      };
    };
}
