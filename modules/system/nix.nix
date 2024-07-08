{ lib, config, inputs, pkgs, ... }:

with lib;
let cfg = config.system.nix;
in
{
  config = {
    nix = {
      settings = {
        auto-optimise-store = true;
        experimental-features = "nix-command flakes";
      };
      registry.nixpkgs.flake = inputs.nixpkgs;
    };
    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      nil
      nixpkgs-fmt
    ];

    impermanence.userDirs = [
      ".cache/nix"
    ];
  };
}
