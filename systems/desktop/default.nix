{ config, pkgs, ... }:

{
  imports = [ ./hardware.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "btrfs" ];

  time.timeZone = "Europe/Stockholm";

  system.networkmanager.enable = true;
  system.pipewire.enable = true;

  desktops.dwm = {
    enable = true;
    xInitExtra = ''
      ${pkgs.xorg.xrandr}/bin/xrandr --output DP-2 --left-of DP-4 --auto
    '';
  };

  apps = {
    develop.enable = true;
    firefox.enable = true;
    discord.enable = true;
    slack.enable = true;
    spotify.enable = true;
    steam.enable = true;
  };

  environment.systemPackages = with pkgs; [
    htop
  ];

  impermanence = {
    enable = true;
    userDirs = [
      "config"
    ];
  };

  system.stateVersion = "23.05";
}
