{ config, lib, ... }:
with lib;
let
  cfg = config.tailscale-containers;
in
{
  options.tailscale-containers = {
    interface = mkOption {
      type = types.str;
      description = ''
        Interface
      '';
    };

    container-data = mkOption {
      type = types.str;
      description = ''
        Container data path
      '';
    };

    containers = mkOption {
      type = types.attrsOf (
        types.submodule (
          { config
          , options
          , name
          , ...
          }: {
            options = {
              extraConfig = mkOption {
                type = types.attrs;
                default = { };
                description = "Extra container config";
              };
              extraBindMounts = mkOption {
                type = types.attrs;
                default = { };
                description = "Extra container bind mounts";
              };
            };
          }
        )
      );
      default = { };
      description = "Tailscale containers";
    };
  };

  config.containers = (
    mapAttrs'
      (name: cfg-container: nameValuePair "${name}" {
        autoStart = true;
        ephemeral = true;
        restartIfChanged = true;
        privateNetwork = true;
        privateUsers = "pick";
        macvlans = [ "${cfg.interface}" ];
        bindMounts = lib.mkMerge [
          {
            "/var/lib/tailscale" = {
              mountPoint = "/var/lib/tailscale:idmap";
              hostPath = "${cfg.container-data}/${name}/tailscale";
              isReadOnly = false;
            };
          }
          cfg-container.extraBindMounts
        ];
        extraFlags = [ "-U" ];
        config = lib.mkMerge [
          {
            networking = {
              hostName = "${name}";
              useDHCP = lib.mkForce true;
            };
            services.tailscale = {
              enable = true;
              interfaceName = "userspace-networking";
            };
            system.stateVersion = "25.05";
          }
          cfg-container.extraConfig
        ];
      })
      cfg.containers
  );
}
