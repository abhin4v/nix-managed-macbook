{
  description = "Nix Darwin + Home Manager configuration of Abhinav Sarkar";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixpkgs-25.05-darwin";
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
    # nix-vscode-extensions = {
    #   url = "github:nix-community/nix-vscode-extensions";
    #   inputs = {
    #     nixpkgs.follows = "nixpkgs";
    #     flake-utils.follows = "flake-utils";
    #   };
    # };
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
    # lix-module = {
    #   url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.3-1.tar.gz";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.flake-utils.follows = "flake-utils";
    # };
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    dm-mono-font = {
      url = "github:googlefonts/dm-mono";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-stable,
      nixpkgs-ghostty,
      nix-darwin,
      home-manager,
      nix-index-database,
      lix-module,
      ...
    }:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
      pkgs-stable = import nixpkgs-stable {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
      pkgs-ghostty = import nixpkgs-ghostty {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
    in
    {
      darwinConfigurations."Abhinavs-M4-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = {
          inherit inputs pkgs-stable;
        };
        modules = [
          ./configuration.nix
          ./homebrew.nix
          lix-module.nixosModules.default
          home-manager.darwinModules.home-manager
          nix-index-database.darwinModules.nix-index
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.abhinav = import ./home.nix;
            home-manager.extraSpecialArgs = {
              inherit inputs pkgs-stable pkgs-ghostty;
              # nixd = inputs.nixd.packages.${system}.nixd;
            };
          }
          { programs.nix-index-database.comma.enable = true; }
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
    };
}
