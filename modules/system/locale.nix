{ lib, config, ... }:

with lib;
let cfg = config.system.locale;
in
{
  config = {
    i18n.defaultLocale = "en_US.UTF-8";
    console = {
      font = "Lat2-Terminus16";
      useXkbConfig = true;
    };
  };
}
