{ lib, config, pkgs, ... }:

with lib;
  let 
    cfg = config.desktops.dwl;
    someblocks = with pkgs; stdenv.mkDerivation rec {
      pname = "someblocks";
      version = "1.0.1";

      src = fetchFromSourcehut {
        owner = "~raphi";
        repo = "someblocks";
        rev = version;
        sha256 = "sha256-pUdiEyhqLx3aMjN0D0y0ykeXF3qjJO0mM8j1gLIf+ww=";
      };

      configFile = ./someblocks.h;
      postPatch = "cp ${configFile} blocks.def.h";

      dontConfigure = true;

      NIX_CFLAGS_COMPILE = [ "-Wno-unused-result" ];

      installFlags = [ "PREFIX=$(out)" ];
    }; 
in
{
  options.desktops.dwl = {
    enable = mkEnableOption "dwl window manager";
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      (self: super: {
        dwl = super.dwl.overrideAttrs (oldAttrs: rec {
          configFile = super.writeText "dwl.h" (builtins.readFile ./dwl.h);
          configMkFile = super.writeText "dwl.mk" (builtins.readFile ./dwl.mk);
          patches = [
            (pkgs.fetchpatch {
              url = "https://github.com/djpohly/dwl/compare/main...dm1tz:04-autostart.patch";
              hash = "sha256-IuWsAeQIOkvM9a9Pjdw+iI8GUbP3vi9m7oxdhuT6YVY=";
            })
          ];
          postPatch = "${oldAttrs.postPatch}\n cp ${configFile} config.def.h\n cp ${configMkFile} config.mk";
        });
        somebar = super.somebar.overrideAttrs (oldAttrs: rec {
          configFile = super.writeText "somebar.hpp" (builtins.readFile ./somebar.hpp);
          prePatch = "cp ${configFile} src/config.def.hpp\n ${oldAttrs.prePatch}";
        });
      })
    ];

    environment.systemPackages = with pkgs; [
      dwl
      foot
      bemenu
      somebar
      someblocks
    ]; 

    home.extraOptions.programs.foot = {
      enable = true;
      settings = {
        main.font = "monospace:size=18";
      };
    };
    
    services.greetd = {
      enable = true;
	    settings = rec {
	      initial_session = {
	        command = "${pkgs.dwl}/bin/dwl -s ${pkgs.somebar}/bin/somebar";
          user = config.user.name;
	      };
        default_session = initial_session;
	    };
    };

    services.dbus.enable = true;
	  xdg.portal = {
	    enable = true;
	    wlr.enable = true;
	    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
	  };

    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-emoji
      liberation_ttf
    ];
  };
}