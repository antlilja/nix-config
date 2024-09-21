{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.apps.common;
in
{
  options.apps.common = {
    enable = mkEnableOption "Enable common programs";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      zip
      unzip
      sxiv
      htop
    ];
  };
}
