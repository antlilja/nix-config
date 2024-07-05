{ options, pkgs, config, lib, inputs, ... }:

with lib;
let cfg = config.home;
in
{
  options.home = {
    extraOptions = mkOption {
      type = types.attrs;
      default = { };
      description = ''
        Options to pass directly to home-manager
      '';
    };
  };

  config = {
    home.extraOptions.home.stateVersion = config.system.stateVersion;
    home-manager = {
      useUserPackages = true;

      users.${config.user.name} = mkAliasDefinitions options.home.extraOptions;
    };
  };
}
