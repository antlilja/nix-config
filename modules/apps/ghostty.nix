{ options, lib, config, ... }:

with lib;
let
  cfg = config.apps.ghostty;
in
{
  options.apps.ghostty = {
    enable = mkEnableOption "Enable ghostty";
  };

  config = mkIf cfg.enable {
    home.extraOptions.programs = {
      ghostty = {
        enable = true;
        settings = {
          theme = "gruvbox-hard-dark";
          window-decoration = "none";
          font-size = 12;
          keybind = [
            "all:ctrl+shift+physical:comma=reload_config"
            "ctrl+shift+escape=close_window"
            "ctrl+shift+tab=goto_split:next"
          ];
        };

        themes.gruvbox-hard-dark = {
          palette = [
            "0=#141617"
            "1=#ea6962"
            "2=#a9b665"
            "3=#d8a657"
            "4=#7daea3"
            "5=#d3869b"
            "6=#89b482"
            "7=#d4be98"
            "8=#32302f"
            "9=#ea6962"
            "10=#a9b665"
            "11=#d8a657"
            "12=#7daea3"
            "13=#d3869b"
            "14=#89b482"
            "15=#d4be98"
          ];
          background = "1d2021";
          foreground = "d4be98";
          cursor-color = "d4be98";
          selection-background = "32302f";
          selection-foreground = "d4be98";
        };
      };
    };

    apps.ssh.matchBlocks."*".setEnv.TERM = "xterm-256color";
  };
}
