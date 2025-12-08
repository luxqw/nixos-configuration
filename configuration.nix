# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs,... }: {

  hardware.graphics = {
    enable = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    modesetting.enable = true;

    powerManagement.enable = false;

    powerManagement.finegrained = false;

    open = false;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.nvidia.prime = {
      sync.enable = true;

      nvidiaBusId = "PCI:1:0:0";
      amdgpuBusId = "PCI:6:0:0";
  };

specialisation = {
  on-the-go.configuration = {
    system.nixos.tags = [ "on-the-go" ];
    hardware.nvidia = {
      prime.offload.enable = lib.mkForce true;
      prime.offload.enableOffloadCmd = lib.mkForce true;
      prime.sync.enable = lib.mkForce false;
    };
  };
};

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  virtualisation.docker.enable = true;
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];

  hardware.bluetooth.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  services.flatpak.enable = true;

  programs.zsh.enable = true;
  programs.steam.enable = true;
  programs.gamemode.enable = true;
  programs.yazi.enable = true;

  services.displayManager.ly.enable = true;
  
  #services.desktopManager.plasma6.enable = true;
  #services.displayManager.sddm.wayland.enable = true;
  #services.displayManager.sddm.enable = true;
  
  fileSystems."/run/media/gamedisk" = {
    device = "/dev/disk/by-label/Games";
    fsType = "ntfs";
    options = [ "nofail" "x-gvfs-show" "uid=1000" "gid=1000" "umask=000" "exec" ];
  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Belgrade";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  users.users.lux = {
    isNormalUser = true;
    description = "lux";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [];
  };
  
  virtualisation.vmware.host.enable = true; 
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    ensureUsers = [
      {
        name = "lux";
        ensurePermissions = {
          "*.*" = "ALL PRIVILEGES";
        };
      }
    ];
  };

  nixpkgs.config.allowUnfree = true;
  services.dbus.enable = true;  
  environment.systemPackages = with pkgs; [
      libreoffice-qt6-fresh
      kdePackages.dolphin
      niri
      jdk
      discord
      dbeaver-bin
      xwayland-satellite
      xdg-desktop-portal-gnome
      wget
      brightnessctl
      yaziPlugins.recycle-bin
      yaziPlugins.projects
      yaziPlugins.mount
      yaziPlugins.mediainfo
      yaziPlugins.full-border
      yaziPlugins.sudo
      yaziPlugins.smart-filter
      yaziPlugins.smart-paste
      yaziPlugins.rich-preview
      yaziPlugins.smart-enter
      yaziPlugins.wl-clipboard
      yaziPlugins.yatline-catppuccin
      mpv
      neovim
      anki
      ntfs3g
      fastfetch
      vesktop
      obsidian
      ffmpeg  
      telegram-desktop
      qbittorrent
      vscode
      tidal-hifi
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # networking.firewall.enable = false;

  system.stateVersion = "25.05";
  
}

