{ lib, config, ... }:

with lib;
let 
  cfg = config.user;
in
{
  options.user = {
    name = mkOption {
      type = types.str;
      default = "antlilja";
      description = ''
        User name
      '';
    };
    email = mkOption {
      type = types.str;
      default = "liljaanton2001@gmail.com";
      description = ''
        User email
      '';
    };
    passwordsPath = mkOption {
      type = types.str;
      default = "/persist/passwords";
      description = ''
        Path where all passwords are stored
      '';
    };
  };

  config = {
    users.mutableUsers = false;
    users.users.root.passwordFile = "${cfg.passwordsPath}/root";

    users.users.${cfg.name} = {
      isNormalUser = true;
      group = "users";
      extraGroups = [ "wheel" ];
      passwordFile = "${cfg.passwordsPath}/${cfg.name}";
    };

    home.extraOptions.xdg = {
      enable = true;
      userDirs = {
        enable = true;
        createDirectories = false;
        desktop = "/home/${cfg.name}/desktop";
        documents = "/home/${cfg.name}/documents";
        download = "/home/${cfg.name}/downloads";
        music = "/home/${cfg.name}/music";
        pictures = "/home/${cfg.name}/pictures";
        videos = "/home/${cfg.name}/videos";
        publicShare = "/home/${cfg.name}/public";
        templates = "/home/${cfg.name}/templates";
      };
    };
  };
}
