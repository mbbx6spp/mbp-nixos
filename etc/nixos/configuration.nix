# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let

in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  #boot.kernelPackages = pkgs.linuxPackages_3_18;
  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = true;
  #boot.loader.systemd-boot.timeout = 2;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.cleanTmpDir = true;
  boot.extraModprobeConfig = ''
    options libata.force=noncq
    options resume=/dev/sda3
    options snd_hda_intel index=0 model=intel-mac-auto id=PCH
    options snd_hda_intel index=1 model=intel-mac-auto id=HDMI
    options snd-hda-intel model=mbp101
    options hid_apple fnmode=2
  '';

  # TODO: update timezone for your needs
  time.timeZone = "America/Chicago";

  fonts.enableFontDir = true;
  fonts.enableCoreFonts = true;
  fonts.enableGhostscriptFonts = true;
  # I like fonts. Sue me.
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

  nix.useSandbox = true;
  nix.binaryCaches =
    [
      https://cache.nixos.org
    ];

  # TODO: Update hostname to your liking
  networking.hostName = "dkmbp0";
  # Manage your /etc/hosts file below
  networking.extraHosts = ''
    127.0.0.1 myawesome.devbox
  '';
  networking.firewall.enable = true;
  networking.wireless.enable = true;

  # TODO: enable bluetooth if you use it on your MBP, otherwise I
  # just disable to save on battery.
  hardware.bluetooth.enable = true;
  # This enables the facetime HD webcam on newer Macbook Pros (mid-2014+).
  hardware.facetimehd.enable = true;
  # Enable pulseaudio for audio
  hardware.pulseaudio.enable = true;
  hardware.opengl.extraPackages = [ pkgs.vaapiIntel ];

  environment.variables = {
    #MY_ENV_VAR = "\${HOME}/bla/bla";
  };
  # minimize the number of systemPackages to essentials because
  # you should keep most of your apps in your user profile.
  environment.systemPackages = with pkgs; [
    # CLI tools
    screen
    tcpdump
    acpi
    vim
    git
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.packageOverrides = pkgs: {
    # TODO: If you need Thunderbolt module you can uncomment the
    # block below:
    #linux = pkgs.linuxPackages.override {
    #  extraConfig = ''
    #    THUNDERBOLT m
    #  '';
    #};
  };

  powerManagement.enable = true;

  programs.light.enable = true;
  programs.bash.enableCompletion = true;

  services.dnsmasq.enable = true;
  # TODO: Update your DNSmasq configuration below to your needs
  services.dnsmasq.extraConfig = ''
    address=/dev/127.0.0.1
    server=/bla.cool/IPHERE
  '';
  # TODO: Update your DNS servers below
  services.dnsmasq.servers = [
    "8.8.4.4"
    "8.8.8.8"
  ];

  services.locate.enable = true;

  # TODO: uncomment and setup your openvpn config below (expects config info
  # in /etc/nixos/mycorp/ dir).
  #services.openvpn.servers.mycorp = {
  #  autoStart = false; # requires you `sudo systemctl start openvpn-mycorp` manually
  #  config = builtins.readFile ./mycorp/openvpn.conf;
  #  up = "${pkgs.update-resolve-conf}/libexec/openvpn/update-resolve-conf";
  #  down = "${pkgs.update-resolve-conf}/libexec/openvpn/update-resolve-conf";
  #};

  services.tlp.enable = true;

  services.xserver.enable = true;
  services.xserver.enableTCP = false;
  services.xserver.layout = "us";
  services.xserver.xkbVariant = "mac";
  #services.xserver.videoDrivers = [ "intel" ];
  services.xserver.xkbOptions = "terminate:ctrl_alt_bksp, ctrl:nocaps";
  # TODO: uncomment if you use an external HTMI monitor
  #services.xserver.xrandrHeads = [ "HDMI-0" "eDP" ];
  #services.xserver.resolutions = [
  #  { x = "3840"; y = "2160"; }
  #  { x = "2880"; y = "1800"; }
  #];

  services.xserver.desktopManager.kde5.enable = true;
  services.xserver.displayManager.kdm.enable = true;

  services.xserver.multitouch.enable = true;
  services.xserver.multitouch.invertScroll = true;

  services.xserver.synaptics.additionalOptions = ''
    Option "VertScrollDelta" "-100"
    Option "HorizScrollDelta" "-100"
  '';
  services.xserver.synaptics.enable = true;
  services.xserver.synaptics.tapButtons = true;
  services.xserver.synaptics.fingersMap = [ 0 0 0 ];
  services.xserver.synaptics.buttonsMap = [ 1 3 2 ];
  services.xserver.synaptics.twoFingerScroll = true;

  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = true;

  users.mutableUsers = true;
  users.ldap.daemon.enable = false;
  # TODO: update username and description, etc.
  users.extraUsers.spotter = {
    isNormalUser = true;
    uid = 1000;
    group = "users";
    description = "Susan Potter";
    extraGroups = [
      "wheel"
      "docker"
      "networkmanager"
      "messagebus"
      "systemd-journal"
      "disk"
      "audio"
      "video"
    ];
    createHome = true;
    home = "/home/spotter";
  };

  virtualisation.docker.enable = true;
}
