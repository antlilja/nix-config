{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.apps.gpg;
in
{
  options.apps.gpg = {
    enable = mkEnableOption "Enable GPG";
  };

  config = mkIf cfg.enable {
    home.extraOptions = {
      programs.gpg.enable = true;
      services.gpg-agent = {
        enable = true;
        enableSshSupport = true;
        pinentryPackage = pkgs.pinentry-curses;
      };
    };
    impermanence.userDirs = [{
      directory = ".gnupg";
      mode = "0700";
    }];
  };
}
