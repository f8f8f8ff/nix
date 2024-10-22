# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # ./ad-blocker.nix
  ];

  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.secrets."restic/password" = {};

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  # boot.loader.grub = {
  #   enable = true;
  #   devices = [ "nodev" ];
  #   efiSupport = true;
  #   useOSProber = true;
  # };

  networking.hostName = "t470"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager = {
    enable = true;
    wifi.powersave = false;
  };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # make sure /srv/data exists
  systemd.tmpfiles.rules = [
    "d /data 0770 root data -"
  ];

  users.groups.data.members = [ "reed" ];
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.reed = {
    isNormalUser = true;
    description = "reed";
    extraGroups = [
      "networkmanager"
      "wheel"
      "restic"
    ];
    packages = with pkgs; [ ];
  };

  # enable flakes
  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    git
    neovim
    qemu
    gh
    at
    restic
  ];

  services.restic.server = {
    enable = true;
    dataDir = "/data/backup";
    extraFlags = ["--no-auth"];
  };
  users.users.restic.extraGroups = [ "data" ];

  services.restic.backups.daily = {
    repository = "rest:http://t470/t470";
    passwordFile = "/run/secrets/restic/password";
    inhibitsSleep = true;
    paths = [ "/home/reed" ];
    exclude = ["/tmp" "/var/cache"];
    timerConfig = {
      OnCalendar = "01:00";
      RandomizedDelaySec = "4h";
      Persistent = true;
    };
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
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;
  services.tailscale.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [
  #   22
  #   # plan9
  #   17010
  #   17013
  #   567
  # ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  systemd.services.plan9 = {
    enable = true;
    description = "9front file+auth+cpu";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    path = [pkgs.qemu];
    serviceConfig = {
      WorkingDirectory="/home/reed/9front-vm";
      ExecStart = "/home/reed/9front-vm/run.sh";
      Restart = "on-failure";
      RestartSec = 1;
    };
  };

  # automatic login
  # services.getty.autologinUser = "reed";

  # no sleep
  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';

  services.atd.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
