{ pkgs, config, lib, ... }:

with lib;
let 
  cfg = config.apps.ssh;
in 
{
  options.apps.ssh = {
    enable = mkEnableOption "Enable SSH";
    matchBlocks = mkOption {
      type = types.attrs;
      default = { };
      description = "SSH match blocks";
    };
  };

  config = mkIf cfg.enable {
    home.extraOptions.programs.ssh = {
      enable = true;
      inherit (cfg) matchBlocks;
    };
    impermanence.userDirs = [{
      directory = ".ssh";
      mode = "0700";
    }];
  };
}