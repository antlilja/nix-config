{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.apps.discord;
in
{
  options.apps.discord = {
    enable = mkEnableOption "Enable Discord";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      discord
    ];
    impermanence.userDirs = [
      ".config/discord"
    ];
  };
}
