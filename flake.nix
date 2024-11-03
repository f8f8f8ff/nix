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

      commonModules =
        { user, host }:
        with inputs;
        [
          (./. + "/hosts/${host}/configuration.nix")
          {
            home-manager = {
              backupFileExtension = "hm-backup";
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${user} = import (./. + "/hosts/${host}/home.nix");
            };
            system.configurationRevision = self.rev or self.dirtyRev or null;
          }
        ];
      darwinModules =
        { user, host }:
        with inputs;
        commonModules { inherit user host; }
        ++ [
          home-manager.darwinModules.home-manager
          {
            users.users.${user}.home = "/Users/${user}";
          }
        ];
      nixosModules =
        { user, host }:
        with inputs;
        commonModules { inherit user host; }
        ++ [
          home-manager.nixosModules.home-manager
        ];
      wslModules =
        { user, host }:
        with inputs;
        nixosModules { inherit user host; }
        ++ [
          nixos-wsl.nixosModules.default
          {
            wsl.enable = true;
          }
        ];
    in
    {
      formatter = forAllSystems (system: nixpkgs.legacyPackages."${system}".nixfmt-rfc-style);

      darwinConfigurations = {
        rdmbp = nix-darwin.lib.darwinSystem {
          system = "x86_64-darwin";
          modules = darwinModules {
            user = "reed";
            host = "macbook";
          };
          specialArgs = {
            inherit inputs;
          };
        };
      };

      nixosConfigurations = {
        cabinet = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules =
            nixosModules {
              user = "reed";
              host = "cabinet";
            }
            ++ [ sops-nix.nixosModules.sops ];
        };

        t470 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules =
            nixosModules {
              user = "reed";
              host = "t470";
            }
            ++ [ sops-nix.nixosModules.sops ];
        };

        REED-PC = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules =
            wslModules {
              user = "reed";
              host = "wsl";
            }
            ++ [
              { system.stateVersion = "24.05"; }
            ];
        };
      };
    };
}
