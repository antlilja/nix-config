{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.desktops.hyprland;
in
{
  options.desktops.hyprland = {
    enable = mkEnableOption "hyprland compositor";
    monitor = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Monitors";
    };
    battery-status = mkOption {
      default = { };
      type = types.submodule {
        options = {
          enable = mkEnableOption "Enable battery status in status bar";
          bat = mkOption {
            type = types.str;
            description = "BAT in /sys/class/power_supply";
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    programs.hyprland.enable = true;
    home.extraOptions = {
      wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = true;
        systemd.enable = true;
        plugins = [
          pkgs.hyprlandPlugins.hyprsplit
        ];
        settings = {
          plugin.hyprsplit = {
            persistent_workspaces = true;
            num_workspaces = 5;
          };
          monitor = cfg.monitor;
          exec-once = [
            "waybar"
            "dunst"
            "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
          ];
          "$mod" = "$SUPER";
          binds.drag_threshold = 10;
          bind = [
            "$mod, BackSpace, exec, firefox"
            "$mod, Return, exec, ghostty"
            "$mod, P, exec, wofi --show drun"
            "$mod, C, killactive"
            "$mod SHIFT, R, exec, reboot"
            "$mod SHIFT, S, exec, shutdown now"
            "$mod, Period, split:swapactiveworkspaces, current +1"
            "$mod, PRINT, exec, slurp | grim -g - ~/$(date \"+%T_%d-%m-%Y\").png"
          ]
          ++ (
            builtins.concatLists (builtins.genList
              (i:
                let ws = i + 1;
                in [
                  "$mod, code:1${toString i}, split:workspace, ${toString ws}"
                  "$mod SHIFT, code:1${toString i}, split:movetoworkspacesilent, ${toString ws}"
                ]
              )
              5)
          );
          bindm = [
            "$mod, mouse:272, movewindow"
            "$mod, mouse:274, resizewindow"
          ];
          bindc = [
            "$mod, mouse:272, togglefloating"
          ];
          binde = [
            ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_SINK@ 1%-"
            ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_SINK@ 1%+"
            ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_SINK@ toggle"
          ];
          general = {
            border_size = 0;
            gaps_in = 0;
            gaps_out = 0;
          };
          ecosystem.no_update_news = true;
          input = {
            kb_layout = "se";
            kb_options = "ctrl:nocaps";
          };
          animations.enabled = "0";
          misc = {
            disable_splash_rendering = true;
            disable_hyprland_logo = true;
          };
          cursor = {
            no_hardware_cursors = "1";
            enable_hyprcursor = false;
          };
        };
      };
      services.dunst.enable = true;
      programs.wofi = {
        enable = true;
        style = ''
          window {
            margin: 0px;
            border: 1px solid #928374;
            background-color: #282828;
          }

          #input {
            margin: 5px;
            border: none;
            color: #ebdbb2;
            background-color: #1d2021;
          }

          #inner-box {
            margin: 5px;
            border: none;
            background-color: #282828;
          }

          #outer-box {
            margin: 5px;
            border: none;
            background-color: #282828;
          }

          #scroll {
            margin: 0px;
            border: none;
          }

          #text {
            margin: 5px;
            border: none;
            color: #ebdbb2;
          }

          #entry:selected {
            background-color: #1d2021;
          }
        '';
      };
      programs.waybar = {
        enable = true;
        settings = {
          main = {
            modules-left = [ "hyprland/workspaces" ];
            modules-right =
              (lib.optionals (cfg.battery-status.enable) [ "battery" ]) ++
              [ "wireplumber" "clock" ];
            clock = {
              tooltip = false;
              format = "{:%H:%M %a %d-%m-%Y}";
            };
            wireplumber = {
              tooltip = false;
              format-muted = "";
            };
            battery = mkIf cfg.battery-status.enable {
              bat = cfg.battery-status.bat;
              format-charging = " {capacity}%";
              format-discharging = " {capacity}%";
            };
            "hyprland/workspaces" = {
              format = "{icon}";
              format-icons = {
                "1" = "1";
                "2" = "2";
                "3" = "3";
                "4" = "4";
                "5" = "5";
                "6" = "1";
                "7" = "2";
                "8" = "3";
                "9" = "4";
                "10" = "5";
              };
              persistent-workspaces = {
                "*" = 5;
              };
            };
          };
        };
        style = ''
          * {
              border: none;
              border-radius: 0;
              min-height: 0;
              margin: 0;
              padding: 0;
          }

          #waybar {
              background: #323232;
              color: white;
              font-family: Cantarell, Noto Sans, sans-serif;
              font-size: 13px;
          }

          #clock,
          #battery,
          #wireplumber {
              padding-left: 5px;
              padding-right: 5px;
          }

          #clock {
              font-weight: bold;
          }

          #battery {
              font-weight: bold;
          }

          #wireplumber {
              font-weight: bold;
          }

          #workspaces button {
              font-weight: bold;
              border-top: 2px solid transparent;
              padding-bottom: 2px;
              padding-left: 10px;
              padding-right: 10px;
              color: #888888;
          }

          #workspaces button.active {
              border-color: #4c7899;
              color: white;
              background-color: #285577;
          }
        '';
      };
    };
    environment.systemPackages = with pkgs; [
      wlr-randr
      apple-cursor
      grim
      slurp
    ];
    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-emoji
      liberation_ttf
      font-awesome
    ];
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "hyprland";
          user = config.user.name;
        };
      };
    };
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    environment.sessionVariables.XCURSOR_THEME = "macOS";
  };
}
