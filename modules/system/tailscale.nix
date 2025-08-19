{ pkgs, lib, config, ... }:

with lib;
let cfg = config.system.tailscale;
in
{
  options.system.tailscale = {
    enable = mkEnableOption "Tailscale";
  };

  config = mkIf cfg.enable {
    services.tailscale.enable = true;

    impermanence = {
      rootDirs = [
        "/var/lib/tailscale"
      ];
    };
  };
}
