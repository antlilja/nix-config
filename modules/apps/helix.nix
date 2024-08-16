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
            file-types = [ "glsl" "vert" "frag" "comp" "rchit" "rgen" "rmiss" "rcall" ];
            language-servers = [ "glsl_analyzer" ];
          }
          {
            name = "c";
            file-types = [ "c" "h" ];
            auto-format = true;
          }
          {
            name = "cpp";
            file-types = [ "cpp" "hpp" ];
            auto-format = true;
          }
          {
            name = "verilog";
            auto-format = true;
            file-types = [ "verilog" "v" "vlg" "vh" ];
            formatter = {
              command = "verible-verilog-format";
              args = [ "-" ];
            };
            language-servers = [ "verible-verilog-ls" ];
          }
        ];
        language-server = {
          glsl_analyzer = {
            command = "glsl_analyzer";
          };
          verible-verilog-ls = {
            command = "verible-verilog-ls";
          };
        };
      };
    };
  };
}
