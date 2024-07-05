{ options, lib, config, ... }:

with lib;
let
  cfg = config.system.networkmanager;
in
{
  options.system.networkmanager = {
    enable = mkEnableOption "Enable NetworkManager";
  };

  config = mkIf cfg.enable {
    networking.networkmanager.enable = true;
    impermanence.rootDirs = [
      "/etc/NetworkManager"
    ];
  };
}
