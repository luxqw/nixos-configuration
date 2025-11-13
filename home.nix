{ config, pkgs, ... }:

{
  home.username = "lux";
  home.homeDirectory = "/home/lux";
  
  home.stateVersion = "25.11"; 

  programs.git.enable = true;

  #programs.bash = {
  #  enable = true;
  # shellAliases = {
  #    rebuild = "sudo nixos-rebuild switch";
  #    rebuild-home = "home-manager switch";
  #    edit-home = "sudo vim /home/lux/.config/home-manager/home.nix";
  #    edit = "sudo vim /etc/nixos/configuration.nix";
  #    update = "sudo nix-channel --update && nixos-rebuild switch && reboot";
  #  };
  #};
  
  programs.mpv.enable = true;


  programs.zsh = {
  enable = true;
  enableCompletion = true;
  autosuggestion.enable = true;
  syntaxHighlighting.enable = true;

  shellAliases = {
    ll = "ls -l";
    update = "sudo nixos-rebuild switch";
  };
  history.size = 10000;

  oh-my-zsh = { # "ohMyZsh" without Home Manager
    enable = true;
    plugins = [ "git" ];
    theme = "sammy";
  };
};

programs.helix = {
  enable = true;
  settings = {
    theme = "autumn_night_transparent";
    editor.cursor-shape = {
      normal = "block";
      insert = "bar";
      select = "underline";
    };
  };
  languages.language = [{
    name = "nix";
    auto-format = true;
    formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
  }];
  themes = {
    autumn_night_transparent = {
      "inherits" = "autumn_night";
      "ui.background" = { };
    };
  };
};

  programs.alacritty.enable = true; # Super+T in the default setting (terminal)
  programs.fuzzel.enable = true; # Super+D in the default setting (app launcher)
  programs.swaylock.enable = true; # Super+Alt+L in the default setting (screen locker)
  programs.waybar.enable = true; # launch on startup in the default setting (bar)
  services.mako.enable = true; # notification daemon
  services.swayidle.enable = true; # idle management daemon
  services.polkit-gnome.enable = true; # polkit

  home.packages = with pkgs; [
    swaybg # wallpaper
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # inode/directory is the MIME type for folders
      "inode/directory" = "org.kde.dolphin.desktop";
    };
  };

  xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        kdePackages.xdg-desktop-portal-kde
      ];
      config = {
        # Use the 'kde' portal specifically for the file chooser interface
        common."org.freedesktop.impl.portal.FileChooser" = "kde"; 
      };
    };

  # ... other home-manager config ...

  xdg.configFile."niri/config.kdl".source = ./config.kdl;
}
