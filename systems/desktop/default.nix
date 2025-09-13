{ config, pkgs, ... }:

{
  imports = [ ./hardware.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "btrfs" ];

  time.timeZone = "Europe/Stockholm";

  system.networkmanager.enable = true;
  system.pipewire.enable = true;

  desktops.hyprland = {
    enable = true;
    monitor = [
      "DP-2, 1920x1080@60, 0x0, 1"
      "DP-3, 2560x1440@144, 1920x0, 1"
    ];
  };

  apps = {
    ghostty.enable = true;
    common.enable = true;
    develop.enable = true;
    firefox.enable = true;
    discord.enable = true;
    slack.enable = true;
    spotify.enable = true;
    steam.enable = true;
    podman.enable = true;
  };

  environment.systemPackages = with pkgs; [
    gimp
  ];

  system.tailscale.enable = true;

  impermanence = {
    enable = true;
    userDirs = [
      "config"
    ];
  };

  system.stateVersion = "23.05";
}
