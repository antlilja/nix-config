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
          lsp.display-inlay-hints = true;
        };
        keys.normal.esc = [ "collapse_selection" "keep_primary_selection" ];
      };
      languages = {
        language = [
          {
            name = "nix";
            auto-format = true;
            formatter.command = "nixpkgs-fmt";
          }
          {
            name = "glsl";
            auto-format = true;
            file-types = [ "glsl" "vert" "frag" "comp" "rchit" "rgen" "rmiss" ];
            language-servers = [ "glsl_analyzer" ];
          }
          {
            name = "c";
            auto-format = true;
          }
        ];
        language-server = {
          glsl_analyzer = {
            command = "glsl_analyzer";
          };
        };
      };
    };
  };
}
