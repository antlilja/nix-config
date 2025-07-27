{ pkgs, lib, config, ... }:

with lib;
let cfg = config.system.bluetooth;
in
{
  options.system.bluetooth = {
    enable = mkEnableOption "Bluetooth";
  };

  config = mkIf cfg.enable {
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
    environment.systemPackages = with pkgs; [
      bluetui
    ];
    impermanence.rootDirs = [
      "/var/lib/bluetooth"
    ];
  };
}
