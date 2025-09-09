{ pkgs, lib, config, ... }:

with lib;
let cfg = config.system.tailscale;
in
{
  options.system.tailscale = {
    enable = mkEnableOption "Tailscale";
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      (_: prev: {
        tailscale = prev.tailscale.overrideAttrs (old: {
          checkFlags =
            builtins.map
              (
                flag:
                if prev.lib.hasPrefix "-skip=" flag
                then flag + "|^TestGetList$|^TestIgnoreLocallyBoundPorts$|^TestPoller$"
                else flag
              )
              old.checkFlags;
        });
      })
    ];
    services.tailscale.enable = true;

    impermanence = {
      rootDirs = [
        "/var/lib/tailscale"
      ];
    };
  };
}
