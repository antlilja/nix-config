{ lib, config, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  boot.initrd.luks.devices."enc".device = "/dev/disk/by-label/encroot";

  fileSystems."/" = {
    device = "/dev/mapper/enc";
    fsType = "btrfs";
    options = [ "defaults" "subvol=root" "compress=lzo" "noatime" ];
  };

  fileSystems."/nix" = {
    device = "/dev/mapper/enc";
    fsType = "btrfs";
    options = [ "defaults" "subvol=nix" "compress=lzo" "noatime" ];
  };

  fileSystems."/persist" = {
    device = "/dev/mapper/enc";
    fsType = "btrfs";
    options = [ "defaults" "subvol=persist" "compress=lzo" "noatime" ];
    neededForBoot = true;
  };

  fileSystems."/var/log" = {
    device = "/dev/mapper/enc";
    fsType = "btrfs";
    options = [ "defaults" "subvol=log" "compress=lzo" "noatime" ];
  };

  fileSystems."/swap" = {
    device = "/dev/mapper/enc";
    fsType = "btrfs";
    options = [ "subvol=swap" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
    options = [ "umask=0077" ];
  };

  swapDevices = [{ device = "/swap/swapfile"; }];

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
    };
    nvidia = {
      open = false;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
