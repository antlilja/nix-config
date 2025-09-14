{ config, lib, ... }:
with lib;
let
  cfg = config.tailscale-containers.jellyfin;
in
{
  options.tailscale-containers.jellyfin = {
    enable = mkEnableOption "Enable Jellyfin container";
  };

  config = mkIf cfg.enable {
    tailscale-containers.containers.jellyfin = {
      extraBindMounts = {
        "/var/lib/jellyfin" = {
          mountPoint = "/var/lib/jellyfin:idmap";
          hostPath = "${config.tailscale-containers.container-data}/jellyfin/jellyfin";
          isReadOnly = false;
        };
      };
      extraConfig = {
        services.jellyfin.enable = true;
      };
    };
  };
}
