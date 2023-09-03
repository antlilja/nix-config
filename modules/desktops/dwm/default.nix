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
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      (self: super: {
        dwm = super.dwm.overrideAttrs (oldAttrs: rec {
          configFile = super.writeText "config.h" (builtins.readFile ./config.def.h);
          postPatch = "${oldAttrs.postPatch}\n cp ${configFile} config.def.h";
        });
      })
      (self: super: {
        dwmblocks = super.dwmblocks.overrideAttrs (oldAttrs: rec {
          configFile = super.writeText "blocks.h" (if cfg.displayBatteryStatus then ''
            static const Block blocks[] = {
            	/*Icon*/	/*Command*/		/*Update Interval*/	/*Update Signal*/
            	{"", "echo $(cat /sys/class/power_supply/BAT0/status) $(cat /sys/class/power_supply/BAT0/capacity)",	60,	0},
            	{"", "wpctl get-volume @DEFAULT_SINK@ | awk -F. '{ print $NF \"%\" }'",	60,	10},
            	{"", "date '+%d/%m/%Y %H:%M'",	60,	0},
            };
            
            //sets delimeter between status commands. NULL character ('\0') means no delimeter.
            static char delim[] = " | ";
            static unsigned int delimLen = 5;
          '' else ''
            static const Block blocks[] = {
            	/*Icon*/	/*Command*/		/*Update Interval*/	/*Update Signal*/
            	{"", "wpctl get-volume @DEFAULT_SINK@ | awk -F. '{ print $NF \"%\" }'",	60,	10},
            	{"", "date '+%d/%m/%Y %H:%M'",	60,	0},
            };
            
            //sets delimeter between status commands. NULL character ('\0') means no delimeter.
            static char delim[] = " | ";
            static unsigned int delimLen = 5;
          '');
          postPatch = "${oldAttrs.postPatch}\n cp ${configFile} blocks.def.h";
        });
      })
    ];

    services.xserver = {
      enable = true;
      displayManager.startx.enable = true;
      layout = "se";
      xkbOptions = "ctrl:nocaps";
      libinput = mkIf cfg.hasTouchpad {
        enable = true;
        touchpad = {
          tapping = false;
        };
      };
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

    home.extraOptions.home.file.".xinitrc".text = cfg.xInitExtra + ''
      ${pkgs.xorg.xsetroot}/bin/xsetroot -bg black
      ${pkgs.dwmblocks}/bin/dwmblocks &
      ${pkgs.dwm}/bin/dwm
    '';
  };
}