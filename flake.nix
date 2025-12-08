{
  description = "My flawless NixOS flake";

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

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
        # to have it up-to-date or simply don't specify the nixpkgs input
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };


  };

  outputs = inputs@{ self, nixpkgs, home-manager, quickshell, noctalia, zen-browser, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
     
      specialArgs = { inherit inputs; };

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

            extraSpecialArgs = { inherit inputs; };
          
            users.lux = import ./home.nix;
            backupFileExtension = "backup";
          };
        }
      ];
    };
  };
}
