{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.apps.firefox;
in
{
  options.apps.firefox = {
    enable = mkEnableOption "Enable Firefox";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      firefox
    ];
    impermanence.userDirs = [
      ".mozilla"
    ];
  };
}
