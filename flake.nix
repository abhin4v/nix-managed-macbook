{
  description = "Nix Darwin + Home Manager configuration of Abhinav Sarkar";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils.follows = "flake-utils";
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.90.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    dm-mono-font = {
      url = "github:googlefonts/dm-mono";
      flake = false;
    };
    monaspace-font = {
      url = "github:githubnext/monaspace";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager, lix-module, ... }:
    let
      system = "x86_64-darwin";
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };
    in {
      darwinConfigurations."Abhinavs-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          ./homebrew.nix
          lix-module.nixosModules.default
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.abhinav = import ./home.nix;
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [ (import home-manager { inherit pkgs; }).home-manager just ];
        shellHook = ''
          export NIXPKGS_PATH=${pkgs.path};
        '';
      };
    };
}
