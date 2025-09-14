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
        lfs.enable = true;
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

      lazygit = mkIf cfg.lazygit {
        enable = true;
        settings = {
          showRandomTip = false;
          disableStartupPopups = true;
        };
      };
    };
  };
}
