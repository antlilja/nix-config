{ pkgs, config, lib, ... }:

with lib;
let 
  cfg = config.apps.helix;
in 
{
  options.apps.helix.enable = mkEnableOption "Helix text editor";

  config = mkIf cfg.enable {
    home.extraOptions.programs.helix = {
      enable = true;
      settings = {
        theme = "gruvbox";
        editor = {
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
          idle-timeout = 50;
          bufferline = "always";
        };
        keys.normal.esc = [ "collapse_selection" "keep_primary_selection" ];
      };
    };
  };
}