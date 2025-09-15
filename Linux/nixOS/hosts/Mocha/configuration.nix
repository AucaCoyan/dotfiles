# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  # inputs, # for home-manager, unused
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # inputs.home-manager.nixosModules.default # unused
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Use the local time so windows don't reset to UTC
  time.hardwareClockInLocalTime = true;

  services.samba = {
    enable = true;
  };

  # Enable avahi for finding *.local domains
  # this is required for samba and local websites
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

  # Samba folders
  # source here:
  # https://www.reddit.com/r/NixOS/comments/6ft8do/mounting_samba_shares_in_nixos/
  #
  # you will need to create the file /etc/nixos/smb-secrets with
  # ```
  # username=Freddie
  # password=BadPassword1234
  # ```
  # so the system can find the credentials
  # Do:
  # `sudo nvim` and then `:w /etc/nixos/smb-secrets`
  fileSystems."/mnt/samba_share/Documentos" = {
    device = "//192.168.0.8/Documents";
    fsType = "cifs";
    options =
      let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
      in
      [ "${automount_opts},credentials=/etc/nixos/smb-secrets,uid=1000,gid=100" ];
  };

  fileSystems."/mnt/samba_share/movies" = {
    device = "//192.168.0.8/movies";
    fsType = "cifs";
    options =
      let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
      in
      [ "${automount_opts},credentials=/etc/nixos/smb-secrets,uid=1000,gid=100" ];
  };

  fileSystems."/mnt/samba_share/Music" = {
    device = "//192.168.0.8/Music";
    fsType = "cifs";
    options =
      let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
      in
      [ "${automount_opts},credentials=/etc/nixos/smb-secrets,uid=1000,gid=100" ];
  };

  fileSystems."/mnt/samba_share/titan" = {
    device = "//192.168.0.8/titan";
    fsType = "cifs";
    options =
      let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
      in
      [ "${automount_opts},credentials=/etc/nixos/smb-secrets,uid=1000,gid=100" ];
  };

  fileSystems."/mnt/samba_share/tvseries" = {
    device = "//192.168.0.8/tvseries";
    fsType = "cifs";
    options =
      let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
      in
      [ "${automount_opts},credentials=/etc/nixos/smb-secrets,uid=1000,gid=100" ];
  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

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
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;
  # Desktop environment
  # https://wiki.nixos.org/wiki/Category:Desktop_environment
  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

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
      kdePackages.kate
      #  thunderbird
    ];
  };

  environment = {
    variables = {
      NH_FLAKE = "/home/aucac/repos/dotfiles/Linux/nixOS/hosts/Mocha";
    };
    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/aucac/.steam/root/compatibilitytools.d";
    };
  };

  programs = {
    firefox.enable = true;

    git = {
      enable = true;
      config = {
        user.name = "Auca Coyan";
        user.email = "aucacoyan@gmail.com";
        init.defaultBranch = "main";
        pull.rebase = true;
        push.autoSetupRemote = true;
      };
    };

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };

    nh.enable = true;

    # Run unpatched dynamic binaries on NixOS.
    # see: github.com/nix-community/nix-ld
    nix-ld.enable = true;
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
    element-desktop # matrix client
    fd
    fnm
    freefilesync
    fsearch
    fzf
    gcc
    gh
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
    systemctl-tui
    telegram-desktop
    ticktick
    tig
    tokei
    vlc
    vscode
    wget
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
