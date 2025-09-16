{ config, lib, pkgs, ... }: {
  
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

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Istanbul";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "tr_TR.UTF-8";
    LC_IDENTIFICATION = "tr_TR.UTF-8";
    LC_MEASUREMENT = "tr_TR.UTF-8";
    LC_MONETARY = "tr_TR.UTF-8";
    LC_NAME = "tr_TR.UTF-8";
    LC_NUMERIC = "tr_TR.UTF-8";
    LC_PAPER = "tr_TR.UTF-8";
    LC_TELEPHONE = "tr_TR.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.flatpak.enable = true;
   
  services.power-profiles-daemon.enable = false;  
  services.auto-cpufreq.enable = true;
    
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lux = {
    isNormalUser = true;
    description = "Lux";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  programs.steam.enable = true;
  programs.gamemode.enable = true;
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
      wget
      anki
      gnome-tweaks
      gradia
      krita
      home-manager
      vim
      ntfs3g
      fastfetch      
      discord
      flclash
      obsidian
      protonup-qt
      flatpak  
      auto-cpufreq
      telegram-desktop
      librewolf
      gnomeExtensions.appindicator
      libepoxy
      vlc
      git
      qbittorrent
      vscode
      yt-dlp
      (python3.withPackages (python-pkgs: with python-pkgs; [
      pandas
      requests
      pytelegrambotapi
  ]))
];

programs.appimage = {
  enable = true;
  binfmt = true;
  package = pkgs.appimage-run.override {
      # Extra libraries and packages for Appimage run
      extraPkgs = pkgs:
        with pkgs; [
          libepoxy
          brotli
          xdg-user-dirs
        ];
    };
};

  fileSystems."/run/media/gamedisk" = {
    device = "/dev/disk/by-label/Games";
    fsType = "ntfs";
    options = [ "nofail" "x-gvfs-show" "uid=1000" "gid=1000" "umask=000" "exec" ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [

    # Add any missing dynamic libraries for unpackaged programs

    # here, NOT in environment.systemPackages

  ];
}
