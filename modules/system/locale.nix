{ lib, config, ... }:

with lib;
let cfg = config.system.locale;
in
{
  config = {
    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = {
        LC_ADDRESS = "sv_SE.UTF-8";
        LC_MEASUREMENT = "sv_SE.UTF-8";
        LC_MESSAGES = "en_US.UTF-8";
        LC_MONETARY = "sv_SE.UTF-8";
        LC_NAME = "sv_SE.UTF-8";
        LC_NUMERIC = "sv_SE.UTF-8";
        LC_PAPER = "sv_SE.UTF-8";
        LC_TELEPHONE = "sv_SE.UTF-8";
        LC_TIME = "sv_SE.UTF-8";
        LC_COLLATE = "sv_SE.UTF-8";
      };
    };
    console = {
      font = "Lat2-Terminus16";
      keyMap = "sv-latin1";
    };
  };
}
