{ config, lib, ... }:
with lib;
let
  cfg = config.tailscale-containers.immich;
in
{
  options.tailscale-containers.immich = {
    enable = mkEnableOption "Enable Immich container";
  };

  config = mkIf cfg.enable {
    tailscale-containers.containers.immich = {
      extraBindMounts = {
        "/var/lib/immich" = {
          mountPoint = "/var/lib/immich:idmap";
          hostPath = "${config.tailscale-containers.container-data}/immich/immich";
          isReadOnly = false;
        };
        "/var/lib/postgresql" = {
          mountPoint = "/var/lib/postgresql:idmap";
          hostPath = "${config.tailscale-containers.container-data}/immich/postgresql";
          isReadOnly = false;
        };
      };
      extraConfig = {
        services.immich = {
          enable = true;
          host = "0.0.0.0";
          machine-learning.enable = false;
        };
      };
    };
  };
}
