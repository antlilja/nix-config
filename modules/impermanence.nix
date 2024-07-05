{ options, pkgs, lib, config, ... }:

with lib;
let
  cfg = config.impermanence;
in
{
  options.impermanence = {
    enable = mkEnableOption "Enable impermanence";
    persistPath = mkOption {
      type = types.str;
      default = "/persist";
      description = ''
        Persist path
      '';
    };
    rootDirs = mkOption {
      type = types.listOf types.attrs;
      default = [ ];
      description = ''
        Root directories to persist
      '';
    };
    rootFiles = mkOption {
      type = types.listOf types.attrs;
      default = [ ];
      description = ''
        Root files to persist
      '';
    };
    userDirs = mkOption {
      type = types.listOf types.attrs;
      default = [ ];
      description = ''
        User directories to persist
      '';
    };
    userFiles = mkOption {
      type = types.listOf types.attrs;
      default = [ ];
      description = ''
        User files to persist
      '';
    };
  };

  config = mkIf cfg.enable {
    impermanence = {
      rootFiles = [
        "/etc/adjtime"
        "/etc/machine-id"
      ];
    };
    security.sudo.extraConfig = ''
      Defaults lecture = never
    '';

    environment.persistence.${cfg.persistPath} = {
      hideMounts = true;
      directories = mkAliasDefinitions options.impermanence.rootDirs;
      files = mkAliasDefinitions options.impermanence.rootFiles;
      users.${config.user.name} = {
        directories = mkAliasDefinitions options.impermanence.userDirs;
        files = mkAliasDefinitions options.impermanence.userFiles;
      };
    };

    boot.initrd.postDeviceCommands = pkgs.lib.mkBefore ''
      mkdir -p /mnt

      # We first mount the btrfs root to /mnt
      # so we can manipulate btrfs subvolumes.
      mount -o subvol=/ /dev/mapper/enc /mnt

      # While we're tempted to just delete /root and create
      # a new snapshot from /root-blank, /root is already
      # populated at this point with a number of subvolumes,
      # which makes `btrfs subvolume delete` fail.
      # So, we remove them first.
      #
      # /root contains subvolumes:
      # - /root/var/lib/portables
      # - /root/var/lib/machines
      #
      # I suspect these are related to systemd-nspawn, but
      # since I don't use it I'm not 100% sure.
      # Anyhow, deleting these subvolumes hasn't resulted
      # in any issues so far, except for fairly
      # benign-looking errors from systemd-tmpfiles.
      btrfs subvolume list -o /mnt/root |
      cut -f9 -d' ' |
      while read subvolume; do
        echo "deleting /$subvolume subvolume..."
        btrfs subvolume delete "/mnt/$subvolume"
      done &&
      echo "deleting /root subvolume..." &&
      btrfs subvolume delete /mnt/root

      echo "restoring blank /root subvolume..."
      btrfs subvolume snapshot /mnt/root-blank /mnt/root

      # Once we're done rolling back to a blank snapshot,
      # we can unmount /mnt and continue on the boot process.
      umount /mnt
    '';
  };
}
