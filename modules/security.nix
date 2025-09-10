{ ... }:
{
  config = {
    nix.settings.allowed-users = [ "@wheel" ];
    security.sudo.execWheelOnly = true;
  };
}
