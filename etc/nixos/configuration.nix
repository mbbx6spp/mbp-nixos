# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let

  hsPkgs = with pkgs.haskellPackages; [
    cabal2nix
    cabalInstall
    doctest
    ghc
    ghcCore
    hlint
    pandoc
    pointfree
    purescript
    ShellCheck
    taffybar
    xmobar
    xmonadContrib
    xmonadExtras
    xmonadScreenshot
  ];

in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  #boot.kernelPackages = pkgs.linuxPackages_3_18;
  boot.loader.grub.enable = false;
  boot.loader.gummiboot.enable = true;
  boot.loader.gummiboot.timeout = 2;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.cleanTmpDir = true;
  boot.extraModprobeConfig = ''
    options libata.force=noncq
    options resume=/dev/sda5
    options snd_hda_intel index=0 model=intel-mac-auto id=PCH 
    options snd_hda_intel index=1 model=intel-mac-auto id=HDMI
    options snd-hda-intel model=mbp101
    options hid_apple fnmode=2
  '';
  boot.loader.generationsDir.enable = false;
  boot.loader.generationsDir.copyKernels = false;

  time.timeZone = "America/Chicago";

  fonts.enableFontDir = true;
  fonts.enableCoreFonts = true;
  fonts.enableGhostscriptFonts = true;
  fonts.fonts = with pkgs; [
    corefonts
    inconsolata
    liberation_ttf
    dejavu_fonts
    bakoma_ttf
    gentium
    ubuntu_font_family
    terminus_font
  ];

  nix.useChroot = true;
  nix.trustedBinaryCaches = [ http://hydra.nixos.org ];
  nix.binaryCaches =
    [
      http://cache.nixos.org
      http://hydra.nixos.org
    ];

  networking.hostName = "lookie";
  networking.interfaceMonitor.enable = true;
  networking.firewall.enable = true;
  networking.wireless.enable = true;
  #networking.wicd.enable = true;
  networking.vpnc.services = {
    default = builtins.readFile ./vpnc.conf;
  };

  # don't need it
  hardware.bluetooth.enable = false;

  environment.variables = {
    #Z_HOME = "\${HOME}/src/zedtech";
  };
  environment.systemPackages = with pkgs; [
    # CLI tools
    ack
    bind
    binutils
    pdsh
    psmisc
    file
    gitFull
    htop
    powertop
    silver-searcher
    wget
    curl
    tmux
    screen
    w3m
    links
    mutt
    weechat
    openconnect
    xfontsel
    gitAndTools.hub
    gist
    xclip
    xsel
    fortune
    tig
    weechat
    scrot
    xbindkeys
    pamixer
    xscreensaver
    tk 
    zip
    unzip
    sysdig
    tcpdump
    vcprompt
    cowsay
    figlet
    rlwrap
    tree
    nixbang
    mkpasswd
    jwhois
    jq
    awscli
    xmonad-with-packages
    libressl
    gnupg
    gnupg1compat

    # power management
    acpi

    # web/browsers/communication
    chromium
    firefoxWrapper
    opera
    skype
    hipchat
    dmenu
    stalonetray

    # music/media
    mplayer2
    spotify
    vlc

    #security
    keepassx
    truecrypt
    googleAuthenticator
    openvpn
    vpnc
    nmap

    # virtualization
    vagrant
    packer

    # development
    vim
    python
    pypyPackages.pip
    pypyPackages.virtualenvwrapper
    erlang
    #oraclejdk8
    scala
    sbt
    nixops
  ] ++ hsPkgs;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.firefox.enableGoogleTalkPlugin = true;
  nixpkgs.config.firefox.enableAdobeFlash = true;
  nixpkgs.config.chromium.enablePepperFlash = true;
  nixpkgs.config.chromium.enablePepperPDF = true;
  nixpkgs.config.packageOverrides = pkgs: {
    #jre = pkgs.oraclejre8;
    #jdk = pkgs.oraclejdk8;
    #linux_3_19 = pkgs.linux_3_19.override {
    #  extraConfig = ''
    #    THUNDERBOLT m
    #  '';
    #};
  };

  powerManagement.enable = true;

  programs.light.enable = true;
  programs.ssh.startAgent = true;
  programs.ssh.agentTimeout = "96h";
  programs.bash.enableCompletion = true;

  services.locate.enable = true;
  services.mpd.enable = true;
  services.upower.enable = true;

  services.xserver.enable = true;
  services.xserver.enableTCP = false;
  services.xserver.layout = "us";
  services.xserver.xkbVariant = "mac";
  services.xserver.videoDrivers = [ "intel" "nouveau" ];
  services.xserver.xkbOptions = "terminate:ctrl_alt_bksp, ctrl:nocaps";
  services.xserver.vaapiDrivers = [ pkgs.vaapiIntel ];

  services.xserver.desktopManager.default = "none";
  services.xserver.desktopManager.xterm.enable = false;

  services.xserver.displayManager.slim.enable = true;
  services.xserver.displayManager.desktopManagerHandlesLidAndPower = false;

  services.xserver.windowManager.default = "xmonad";
  services.xserver.windowManager.xmonad.enable = true;
  services.xserver.windowManager.xmonad.enableContribAndExtras = true;
  #services.xserver.windowManager.xmonad.extraPackages = haskellPackages: [
  #  haskellPackages.xmonadScreenshot
  #];

  services.xserver.multitouch.enable = true;
  services.xserver.multitouch.invertScroll = true;

  #services.xserver.startGnuPGAgent = true;

  services.xserver.synaptics.additionalOptions = ''
    Option "VertScrollDelta" "-100"
    Option "HorizScrollDelta" "-100"
  '';
  services.xserver.synaptics.enable = true;
  services.xserver.synaptics.tapButtons = true;
  services.xserver.synaptics.fingersMap = [ 0 0 0 ];
  services.xserver.synaptics.buttonsMap = [ 1 3 2 ];
  services.xserver.synaptics.twoFingerScroll = true;

  # services.xserver.xkbOptions = "eurosign:e";

  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = true;

  users.mutableUsers = true;
  users.ldap.daemon.enable = false;
  users.extraUsers.spotter = {
    isNormalUser = true;
    uid = 1000;
    group = "users";
    description = "Susan Potter";
    extraGroups = [ "wheel" ];
    createHome = true;
    home = "/home/spotter";
  };
}
