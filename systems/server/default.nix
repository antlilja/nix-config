{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware.nix ];

  boot = {
    loader.systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
    loader.efi.canTouchEfiVariables = true;
    supportedFilesystems = [ "btrfs" ];

    initrd = {
      kernelModules = [ "e1000e" ];
      network = {
        enable = true;
        udhcpc.enable = true;
        ssh = {
          enable = true;
          port = 2222;
          authorizedKeys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHuHjLOk09V3+aNPRZeXlZzFmO3gL++a3dSfR2Rbk18/"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINcHtogGoXOYEv6xCZwDnlK86PGoxvViftD+/Wofy+KD"
          ];
          hostKeys = [ "/persist/secrets/initrd/initrd_host_ed25519_key" ];
        };

        postCommands =
          let
            disk = "/dev/disk/by-label/encroot";
          in
          ''
            echo 'cryptsetup open ${disk} enc --type luks && echo > /tmp/continue && exit' >> /root/.profile
            echo 'starting sshd...'
          '';
      };
      postDeviceCommands = lib.mkBefore ''
        echo 'waiting for root device to be opened...'
        mkfifo /tmp/continue
        timeout 30 cat /tmp/continue
      '';
    };
  };

  time.timeZone = "Europe/Stockholm";

  system.networkmanager.enable = true;

  apps = {
    helix.enable = true;
    git = {
      enable = true;
      lazygit = true;
    };
    ssh.enable = true;
  };

  system.tailscale.enable = true;

  impermanence = {
    enable = true;
    rootDirs = [
      "/var/lib/nixos-containers"
    ];
    userDirs = [
      "persist"
      "nix-config"
    ];
  };

  tailscale-containers = {
    interface = "enp0s31f6";
    container-data = "/persist/container-data";

    immich.enable = true;
    gitea.enable = true;
    jellyfin.enable = true;
  };

  system.stateVersion = "25.05";
}
