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

  # Enable the Pantheon Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  # https://wiki.nixos.org/wiki/Category:Desktop_environment
  services.desktopManager.plasma6.enable = true;
  # services.xserver.desktopManager.pantheon.enable = true;

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
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;

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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.variables = {
    NH_FLAKE = "/home/aucac/repos/dotfiles/Linux/nixOS/hosts/Mocha";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alejandra
    bat
    bun
    cargo-tarpaulin # rust coverage
    delta
    difftastic
    discord
    # docker
    # docker-compose
    fd
    fnm
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
    lazygit
    neovim # Nano editor is also installed by default.
    wl-clipboard # for the clipboard interaction
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
    qdirstat
    # postgresql
    ripgrep
    rustup
    signal-desktop
    ticktick
    telegram-desktop
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
