{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.apps.steam;
in
{
  options.apps.steam = {
    enable = mkEnableOption "Enable Steam";
  };

  config = mkIf cfg.enable {
    programs.steam.enable = true;
    environment.systemPackages = with pkgs; [
      protontricks
    ];
    impermanence.userDirs = [
      ".steam"
      ".local/share/Steam"
    ];
  };
}
