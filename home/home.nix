{ config, pkgs, ... }: {
  home.username = "anton";
  home.homeDirectory = "/home/anton";

  nixpkgs.overlays = [
    (import ../overlays/dwm-custom.nix)
  ];

  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "antlilja";
      userEmail = "liljaanton2001@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
	core.editor = "nvim";
      };
    };
    
    neovim.enable = true;      
  };

  home.packages = with pkgs; [
    dwm
    dmenu
    alacritty
    firefox
  ];

  home.file = {
    ".xinitrc".text = "exec dwm";
    ".bash_profile".text = ''
      if [ -z "''${DISPLAY}" ] && [ "''${XDG_VTNR}" -eq 1 ]; then
        exec startx
      fi
    '';
  };
    
  home.stateVersion = "22.05";
}
