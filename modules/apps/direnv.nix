{ config, lib, ... }:

with lib;
let 
  cfg = config.apps.direnv;
in 
{
  options.apps.direnv = {
    enable = mkEnableOption "Enable direnv and nix-direnv";
  };

  config = mkIf cfg.enable {
    home.extraOptions.programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    impermanence.userDirs = mkIf config.impermanence.enable [
      ".local/share/direnv"
    ];
  };
}