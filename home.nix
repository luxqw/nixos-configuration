{ config, pkgs, inputs, ... }:

{
  home.username = "lux";
  home.homeDirectory = "/home/lux";
  
  home.stateVersion = "25.11"; 

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

  imports = [
    inputs.zen-browser.homeModules.default
  ];

  programs.zen-browser = {
    enable = true;
  };

  programs.zsh = {
  enable = true;
  enableCompletion = true;
  autosuggestion.enable = true;
  syntaxHighlighting.enable = true;

  shellAliases = {
    ll = "ls -l";
    update = "sudo nixos-rebuild switch";
    edit = "cd /etc/nixos && sudo nvim .";
  };
  history.size = 10000;

  oh-my-zsh = { # "ohMyZsh" without Home Manager
    enable = true;
    plugins = [ "git" ];
    theme = "sammy";
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
    swaybg
  ];

  xdg.configFile."niri/config.kdl".source = ./config.kdl;
}
