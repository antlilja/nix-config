{ lib, config, ... }:

with lib;
let cfg = config.apps.podman;
in
{
  options.apps.podman.enable = mkEnableOption "Podman";

  config = mkIf cfg.enable {
    virtualisation = {
      podman = {
        enable = true;

        dockerCompat = true;

        defaultNetwork.settings.dns_enabled = true;
      };
    };

    impermanence.userDirs = [
      ".cache/containers"
      ".local/share/containers"
    ];
  };
}
