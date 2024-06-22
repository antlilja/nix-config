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
        dwl = (super.dwl.overrideAttrs (oldAttrs: rec {
          patches = [
            (pkgs.fetchpatch {
              url = "https://codeberg.org/dwl/dwl-patches/raw/commit/4cf16ae5c51aa6db34b656fc2b0fd536100c481b/autostart/autostart.patch";
              hash = "sha256-OGGqnTIpM5bZRUY5j1r8Zy2cDQiLlZKURW5gN56lehY=";
            })
          ];
        })).override { conf = ./dwl.h; };
        somebar = (super.somebar.overrideAttrs(oldAttrs: rec {
          src = pkgs.fetchFromSourcehut {
            owner = "~raphi";
            repo = "somebar";
            rev = "6572b98d697fef50473366bf4b598e66c0be3e54";
            sha256 = "sha256-4s9tj5+lOkYjF5cuFRrR1R1S5nzqvZFq9SUAFuA8QXc=";
          };
        })).override { conf = ./somebar.hpp; };
      })
    ];

    environment.systemPackages = with pkgs; [
      dwl
      foot
      bemenu
      somebar
      someblocks
      wlr-randr
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
