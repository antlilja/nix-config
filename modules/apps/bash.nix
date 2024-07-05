{ lib, config, ... }:

with lib;
let cfg = config.apps.bash;
in
{
  options.apps.bash = {
    historyFile = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Path to history file
      '';
    };
  };

  config = {
    home.extraOptions.programs.bash = {
      enable = true;
      inherit (cfg) historyFile;
      historyIgnore = [ "ls" "cd" "exit" ];
      initExtra =
        if config.apps.git.enable then ''
          parse_git_branch() {
            git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
          }
          PS1="\u \[\e[0;32m\]\w\[\e[91m\] \$(parse_git_branch)\[\e[0m\]$ "
        '' else ''
          PS1="\u \[\e[0;32m\]\w\[\e[91m\]\[\e[0m\]$ "
        '';
    };
    impermanence.userFiles = mkIf (cfg.historyFile == null) [
      ".bash_history"
    ];
  };
}
