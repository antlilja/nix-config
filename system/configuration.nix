{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Nix
  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };
  nixpkgs.config.allowUnfree = true;

  # Boot
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      efiSupport = true;
      device = "nodev";
    };
  };

  # Networking
  networking.hostName = "anton-nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Stockholm";

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  # X11
  services.xserver = {
    enable = true;
    layout = "se";
    displayManager = {
      startx.enable = true;
      setupCommands = "${pkgs.xorg.xrandr}/bin/xrandr --output DP-2 --left-of DP-4";
    };
    videoDrivers = [ "nvidia" ];
  };
  hardware.opengl.enable = true;

  # Sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;
 
  # Users
  users.users.anton = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
  
  system.stateVersion = "22.05";
}

