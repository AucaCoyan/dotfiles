# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.grub.configurationLimit = 42;

  # Use the local time so windows don't reset to UTC
  time.hardwareClockInLocalTime = true;
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than-30d";
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # fileSystems."/mnt/share" = {
  #   device = "//192.168.0.8/";
  #   fsType = "cifs";
  #   options =
  #     let
  #       # this line prevents hanging on network split
  #       automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";

  #     in
  #     [ "${automount_opts},credentials=/etc/nixos/smb-secrets,uid=1000,gid=100" ];
  # };

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Argentina/Buenos_Aires";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_AR.UTF-8";
    LC_IDENTIFICATION = "es_AR.UTF-8";
    LC_MEASUREMENT = "es_AR.UTF-8";
    LC_MONETARY = "es_AR.UTF-8";
    LC_NAME = "es_AR.UTF-8";
    LC_NUMERIC = "es_AR.UTF-8";
    LC_PAPER = "es_AR.UTF-8";
    LC_TELEPHONE = "es_AR.UTF-8";
    LC_TIME = "es_AR.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Desktop environment
  # https://wiki.nixos.org/wiki/Category:Desktop_environment
  services.xserver.displayManager.lightdm.enable = true;

  # KDE
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Cosmic
  # # Enable the login manager
  # services.displayManager.cosmic-greeter.enable = true;
  # # Enable the COSMIC DE itself
  # services.desktopManager.cosmic.enable = true;
  # # Enable XWayland support in COSMIC
  # services.desktopManager.cosmic.xwayland.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true; # powers up BT on boot

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

  # enable avahi for finding *.local domains
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.aucac = {
    isNormalUser = true;
    description = "aucac";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true; # optimizations to the OS

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment = {
    variables = {
      NH_FLAKE = "/home/aucac/repos/dotfiles/Linux/nixOS/hosts/Mocha";
    };
    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/aucac/.steam/root/compatibilitytools.d";
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alejandra
    bat
    bun
    cargo-tarpaulin # rust coverage
    cifs-utils # for the samba shares
    delta
    difftastic
    discord
    # docker
    # docker-compose
    fd
    fnm
    freefilesync
    fsearch
    fzf
    gcc
    gh
    git
    gitmoji-cli
    gfold
    glab
    ghostty
    gparted
    # grafana
    # grafana-loki
    home-manager
    keepassxc
    kdotool
    lazygit
    lnav
    neovim # Nano editor is also installed by default.
    wl-clipboard # for the clipboard interaction
    mangohud # steam fps and gpu monitor
    mattermost-desktop
    mdbook
    nh
    nil # nix LSP
    nixfmt # Official formatter
    nushell
    nvd # diff between nix versions
    obsidian
    oh-my-posh
    onedrive
    openssl
    pkg-config
    protonup # steam's proton
    qdirstat
    # postgresql
    ripgrep
    rustup
    samba
    signal-desktop
    telegram-desktop
    ticktick
    tig
    tokei
    vlc
    vscode
    wget
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.git = {
    enable = true;
    config = {
      user.name = "Auca Coyan";
      user.email = "aucacoyan@gmail.com";
      init.defaultBranch = "main";
    };

    # TODO in home manager
    # extraConfig = {
    #   pull.rebase = true;
    # };
  };

  programs.nh.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

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
  system.stateVersion = "24.05"; # Did you read the comment?

}
