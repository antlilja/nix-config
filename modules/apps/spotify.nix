{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.apps.spotify;
in
{
  options.apps.spotify = {
    enable = mkEnableOption "Enable Spotify";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      spotify
    ];
    impermanence.userDirs = [
      ".config/spotify"
    ];
  };
}
