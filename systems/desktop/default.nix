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
    xScreenSection = ''
      Option "nvidiaXineramaInfoOrder" "DP-4"
      Option "metamodes" "DP-4: 2560x1440_144 +1920+0, DP-2: 1920x1080_100 +0+0"
    '';
  };

  apps = {
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

  impermanence = {
    enable = true;
    userDirs = [
      "config"
    ];
  };

  system.stateVersion = "23.05";
}
