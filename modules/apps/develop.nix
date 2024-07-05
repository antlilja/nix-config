{ config, lib, ... }:

with lib;
let
  cfg = config.apps.develop;
in
{
  options.apps.develop = {
    enable = mkEnableOption "Enable development environment";
  };

  config = mkIf cfg.enable {
    apps = {
      helix.enable = true;
      git = {
        enable = true;
        lazygit = true;
      };
      ssh.enable = true;
      gpg.enable = true;
      direnv.enable = true;
    };
    impermanence.userDirs = [
      "src"
    ];
  };
}
