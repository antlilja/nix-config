{ lib, config, inputs, ... }:

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

    impermanence.userDirs = [
      ".cache/nix"
    ];
  };
}