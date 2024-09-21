{ config, pkgs, ... }:

{
  imports = [ ./hardware.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "btrfs" ];

  time.timeZone = "Europe/Stockholm";

  system.networkmanager.enable = true;
  system.pipewire.enable = true;
  system.bluetooth.enable = true;

  desktops.dwm = {
    enable = true;
    displayBatteryStatus = true;
    hasTouchpad = true;
  };

  apps = {
    develop.enable = true;
    firefox.enable = true;
    discord.enable = true;
    slack.enable = true;
    spotify.enable = true;
  };

  environment.systemPackages = with pkgs; [
    htop
    xdg-utils
  ];

  impermanence = {
    enable = true;
    userDirs = [
      "config"
    ];
  };

  system.stateVersion = "23.05";
}
