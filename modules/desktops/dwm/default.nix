{ lib, config, pkgs, ... }:

with lib;
let cfg = config.desktops.dwm;
in
{
  options.desktops.dwm = {
    enable = mkEnableOption "dwm window manager";
    hasTouchpad = mkEnableOption "Enable touchpad support";
    displayBatteryStatus = mkEnableOption "Display battery status in status bar";
    xInitExtra = mkOption {
      type = types.str;
      default = "";
      description = ".xsession init extra";
    };
    xScreenSection = mkOption {
      type = types.lines;
      default = '''';
      description = "xorg.conf screen section";
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      (self: super: {
        dwm = super.dwm.override { conf = ./config.def.h; };
        dwmblocks = super.dwmblocks.override {
          conf = if cfg.displayBatteryStatus then ./blocks_with_battery.h else ./blocks_without_battery.h;
        };
      })
    ];

    services.xserver = {
      enable = true;
      displayManager.startx.enable = true;
      xkb = {
        layout = "se";
        options = "ctrl:nocaps";
      };
      libinput = mkIf cfg.hasTouchpad {
        enable = true;
        touchpad = {
          tapping = false;
        };
      };
      monitorSection = ''
        Option "DPMS" "false"
      '';
      screenSection = cfg.xScreenSection;
    };

    services.greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = "${pkgs.xorg.xinit}/bin/startx";
          user = config.user.name;
        };
        default_session = initial_session;
      };
    };

    environment.systemPackages = with pkgs; [
      dwm
      alacritty
      dmenu
      dwmblocks
    ];

    home.extraOptions.programs.bash.shellAliases = {
      clone = "alacritty --working-directory $(pwd) & disown";
    };

    home.extraOptions.home.file.".xinitrc".text = cfg.xInitExtra + ''
      ${pkgs.xorg.xsetroot}/bin/xsetroot -bg black
      ${pkgs.dwmblocks}/bin/dwmblocks &
      ${pkgs.dwm}/bin/dwm
    '';
  };
}
