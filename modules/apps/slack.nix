{ pkgs, config, lib, ... }:

with lib;
let 
  cfg = config.apps.slack;
in 
{
  options.apps.slack = {
    enable = mkEnableOption "Enable Slack";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      slack
    ];
    impermanence.userDirs = [
      ".config/Slack"
    ];
  };
}