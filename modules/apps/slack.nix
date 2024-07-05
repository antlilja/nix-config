{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.apps.slack;
in
{
  options.apps.slack = {
    enable = mkEnableOption "Enable Slack";
    wayland = mkEnableOption "Enable wayland support";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      slack
    ];
    environment.sessionVariables.NIXOS_OZONE_WL = mkIf cfg.wayland "1";
    impermanence.userDirs = [
      ".config/Slack"
    ];
  };
}
