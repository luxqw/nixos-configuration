{
  description = "A basic NixOS and Home Manager flake";
  inputs = {  
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, zen-browser, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # Path to your main NixOS configuration
        ./configuration.nix
        home-manager.nixosModules.home-manager
      ];
    };

    homeConfigurations.lux = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      # Pass all inputs to home.nix
      extraSpecialArgs = { inherit inputs; };
      modules = [
        /home/lux/.config/home-manager/home.nix
      ];
    };
  };
}
