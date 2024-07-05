{ pkgs, lib, config, ... }:

with lib;
let cfg = config.system.pipewire;
in
{
  options.system.pipewire = {
    enable = mkEnableOption "Pipewire";
  };

  config = mkIf cfg.enable {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
