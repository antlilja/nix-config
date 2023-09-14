{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager ={
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = inputs: {    
    nixosConfigurations = {
      desktop = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = with inputs; [
          ./systems/desktop
          ./modules
          { networking.hostName = "desktop"; }
          home-manager.nixosModules.home-manager
          impermanence.nixosModule
        ];
        specialArgs = { inherit inputs; };
      };
      laptop = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = with inputs; [
          ./systems/laptop
          ./modules
          { networking.hostName = "laptop"; }
          home-manager.nixosModules.home-manager
          impermanence.nixosModule
        ];
        specialArgs = { inherit inputs; };
      };
    };
  };
}