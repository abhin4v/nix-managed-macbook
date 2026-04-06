{
  description = "Nix Darwin + Home Manager configuration of Abhinav Sarkar";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixpkgs-25.05-darwin";
    nixpkgs-ghostty.url = "github:nixos/nixpkgs/69b9a8c860bdbb977adfa9c5e817ccb717884182";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nixd = {
    #   url = "github:nix-community/nixd/2.6.1";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    lix = {
      url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
      flake = false;
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.lix.follows = "lix";
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
    microvm = {
      url = "github:microvm-nix/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-ghostty,
      nix-darwin,
      home-manager,
      nix-index-database,
      lix-module,
      microvm,
      ...
    }:
    let
      system = "aarch64-darwin";
      microvm-system = builtins.replaceStrings [ "-darwin" ] [ "-linux" ] system;
      hostname = "Abhinavs-M4-MacBook-Pro";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
      # pkgs-stable = import nixpkgs-stable {
      #   inherit system;
      #   config = {
      #     allowUnfree = true;
      #   };
      # };
      pkgs-ghostty = import nixpkgs-ghostty {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
    in
    {
      darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          ./homebrew.nix
          lix-module.darwinModules.default
          home-manager.darwinModules.home-manager
          nix-index-database.darwinModules.nix-index
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.abhinav = import ./home.nix;
            home-manager.extraSpecialArgs = {
              inherit inputs pkgs-ghostty;
              # nixd = inputs.nixd.packages.${system}.nixd;
            };
          }
          { programs.nix-index-database.comma.enable = true; }
          {
            environment.etc."nix/gcroots/microvm-projects".source =
              self.nixosConfigurations.projects-microvm.config.system.build.toplevel;
          }
        ];
      };
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          (import home-manager { inherit pkgs; }).home-manager
          just
          nix-output-monitor
          nvd
        ];
        shellHook = ''
          export NIXPKGS_PATH=${pkgs.path};
        '';
      };
      nixosConfigurations.projects-microvm = nixpkgs.lib.nixosSystem {
        system = microvm-system;
        specialArgs = { inherit inputs; };
        modules = [
          microvm.nixosModules.microvm
          home-manager.nixosModules.home-manager
          ./microvms/projects.nix
          {
            microvm.vmHostPackages = nixpkgs.legacyPackages.${system};
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.root = {
              imports = [ ./programs/shared.nix ];
              home.stateVersion = "25.05";
            };
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };
      packages.${system}.projects-microvm =
        let
          runner = self.nixosConfigurations.projects-microvm.config.microvm.declaredRunner;
        in
        pkgs.writeShellScriptBin "microvm-run" ''
          cleanup() { stty "$(stty -g)"; }
          trap cleanup EXIT
          stty intr ^] susp ^] quit ^]
          exec ${runner}/bin/microvm-run
        '';
    };
}
