{
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
        home-manager = {
            inputs.nixpkgs.follows = "nixpkgs";
            url = "github:nix-community/home-manager";
        };
    };

    outputs = { self, nixpkgs, home-manager, ... }: 
    let
        system = "x86_64-linux";
        pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
        };
    in
    {
        nixosConfigurations = {
            anton-nixos = nixpkgs.lib.nixosSystem {
                inherit system;
                modules = [ ./system/configuration.nix ];
            };
        };  	

        homeConfigurations = {
            "anton@anton-nixos" = home-manager.lib.homeManagerConfiguration {
                inherit pkgs;
                modules = [ ./home/home.nix ];
            };
        };
    };
}
