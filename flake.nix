{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    home-manager.url = "github:nix-community/home-manager";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixos-wsl,
      home-manager,
      nix-darwin,
      sops-nix,
      ...
    }:
    let
      forAllSystems = nixpkgs.lib.attrsets.genAttrs [
        "x86_64-linux"
        "x86_64-darwin"
      ];
    in
    {
      formatter = forAllSystems (system: nixpkgs.legacyPackages."${system}".nixfmt-rfc-style);

      nixosConfigurations = {
        REED-PC = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/wsl/configuration.nix

            nixos-wsl.nixosModules.default
            {
              system.stateVersion = "24.05";
              wsl.enable = true;
            }

            home-manager.nixosModules.home-manager
            {
              home-manager.backupFileExtension = "hm-backup";
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.reed = import ./hosts/wsl/home.nix;

              # Optionally, use home-manager.extraSpecialArgs to pass
              # arguments to home.nix
            }
          ];
        };

        "t470" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/t470/configuration.nix
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            {
              home-manager.backupFileExtension = "hm-backup";
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.reed = import ./hosts/t470/home.nix;
            }
          ];
        };
      };

      darwinConfigurations = {
        "rdmbp" = nix-darwin.lib.darwinSystem {
          system = "x86_64-darwin";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            (./overlays)
            # Set Git commit hash for darwin-version.
            {
              system.configurationRevision = self.rev or self.dirtyRev or null;
            }

            ./hosts/macbook/configuration.nix

            home-manager.darwinModules.home-manager
            {
              home-manager.backupFileExtension = "hm-backup";
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.reed = import ./hosts/macbook/home.nix;
            }
          ];
        };
      };
    };
}
