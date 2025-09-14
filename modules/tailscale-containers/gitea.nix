{ config, lib, ... }:
with lib;
let
  cfg = config.tailscale-containers.gitea;
in
{
  options.tailscale-containers.gitea = {
    enable = mkEnableOption "Enable Gitea container";
  };

  config = mkIf cfg.enable {
    tailscale-containers.containers.gitea = {

      extraBindMounts = {
        "/var/lib/gitea" = {
          mountPoint = "/var/lib/gitea:idmap";
          hostPath = "${config.tailscale-containers.container-data}/gitea/gitea";
          isReadOnly = false;
        };
        "/etc/ssh/keys" = {
          mountPoint = "/etc/ssh/keys:idmap";
          hostPath = "${config.tailscale-containers.container-data}/gitea/ssh";
          isReadOnly = false;
        };
      };
      extraConfig = {
        services.fail2ban.enable = true;
        services.openssh = {
          enable = true;
          openFirewall = false;
          settings = {
            PasswordAuthentication = false;
            KbdInteractiveAuthentication = false;
            PermitEmptyPasswords = "no";
            PermitRootLogin = "no";
          };
          hostKeys = [
            {
              bits = 4096;
              path = "/etc/ssh/keys/ssh_host_rsa_key";
              type = "rsa";
            }
            {
              path = "/etc/ssh/keys/ssh_host_ed25519_key";
              type = "ed25519";
            }
          ];
        };
        services.gitea = {
          enable = true;
          lfs.enable = true;
          appName = "Private Gitea server";
          database.type = "sqlite3";
          settings = {
            server = {
              DOMAIN = "gitea.typhon-city.ts.net";
              ROOT_URL = "https://gitea.typhon-city.ts.net/";
            };
            service = {
              DISABLE_REGISTRATION = true;
            };
            repository = {
              GO_GET_CLONE_URL_PROTOCOL = "ssh";
              USE_COMPAT_SSH_URI = false;
            };
          };
        };
      };
    };
  };
}
