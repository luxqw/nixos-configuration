{
  description = "My flawless NixOS flake!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    quickshell = {
      url = "github:outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.quickshell.follows = "quickshell";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, quickshell, noctalia,  ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        ./configuration.nix

  ({ config, pkgs, lib, ... } @ args:
    import ./noctalia.nix (args // {
      inherit noctalia;
    })
  )

        home-manager.nixosModules.home-manager
        {
	    programs.niri.enable = true;

            home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.lux = import ./home.nix;
            backupFileExtension = "backup";
          };
        }
      ];
    };
  };
}
