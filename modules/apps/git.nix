{ options, lib, config, ... }:

with lib;
let 
  cfg = config.apps.git;
in
{
  options.apps.git = {
    enable = mkEnableOption "Enable git";
    lazygit = mkEnableOption "Enable lazygit";
  };

  config = mkIf cfg.enable {
    home.extraOptions.programs = {
      git = {
        enable = true;
        userName = config.user.name;
        userEmail = config.user.email;
        ignores = mkIf config.apps.direnv.enable [
          ".direnv"
          ".envrc"
        ];
        extraConfig = {
          init.defaultBranch = "main";
          core.editor = mkIf config.apps.helix.enable "hx";
        };
      };
      lazygit.enable = cfg.lazygit;
    };    

    apps.ssh.matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "antlilja";
        identityFile = "~/.ssh/id_github";
        identitiesOnly = true;
      };
      "gits-15.sys.kth.se" = {
        hostname = "gits-15.sys.kth.se";
        user = "antlilja";
        identityFile = "~/.ssh/id_kth";
        identitiesOnly = true;
      };
    };
  };
}
