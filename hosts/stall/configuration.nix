{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix # generated at runtime by nixos-infect
  ];

  time.timeZone = "America/Los_Angeles";

  users.users.reed = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages =
      with pkgs;
      [
      ];
    openssh.authorizedKeys.keys = config.users.users.root.openssh.authorizedKeys.keys;
  };

  environment.systemPackages = with pkgs; [
    git
    tmux
    btop
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  services.tailscale.enable = true;

  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "stall";
  networking.domain = "";
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKT53qW9SWxJhoMYARlQ/1aj94os+Lvk8HVqK8WOkYDa reed@cabinet''
    ''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDOb2lPMu4qehSSIjbTgDpqmboYjoMeV8LVTYQbSs4+0HUTHyMm/LxMVO//lloo/LwYFQeOSLRhWxJjqaIMbB46uSZOtMCc0kfh4ZJSlap4G66ipHBzSYQnBn3n2mqrsX1M9jND1Ww+T3KqBbmiU6f6P4J8bK5M8SRj4K/jsYl206gzycKvFsq3Z30erBnyfrxvs9yDoVfVCP0PsnVFBeYRM5Glce8KoWulqv6rRKRSeqFF3dsEbw5h3xlieKpr4OInrcUKEuOJEFLI6nLbCk1MH/hgxTRygh2MZZtblgubA13MK3D/+7TpEt2ReUUmC+jzqYti1D4i9nLVSOre8YoXICdHBue1d7F7l47VE0wjZtkCZBhZaOOz8FPOI14QZDIIyHo+YFkRHDXQwSf32A8fSJMb39H3FF43e44fHDyjdGTwVlH7KROMlpPd3AyQReHyiLb+YrDqUkv8FHpPC5CFftjDq+Y9BI5D5j8joResH8A7LPrJPhkWQUunf3UA/Rc= reed@book.local''
    ''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDKCzBgUiM4fhy9FgMnO1fiBEU4oMZRcvp0V0/SDiZwnOaIidXgHfk9L7PjGuwE/pbrpyL8Da8Cv24ETqZgr6btcWUaN68MI8CQNIYONL+hzDIvKx9wl4Of3ffljZB1F2Tu8vWYegvJkSRV4h0bjT1s4qnqy4U3wbIgcH4824bMdyNA3+3knAZSYD3qbRzqZ033oQ/xrZ/sfBOmcU19JuZsvWB+HQIPoAcnk7F5P0Iak68/sNh7vq/wL3lzOHEAIM4ViznIo8Sd2LlNKSqVSGjYSImTNI0XsEfZkrvatuy0RTMlFu1z6ZnAx1Suc+GwDMCE4LsQ7W+4jEZHrolOun3t reed@reed-tp''
    ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILtIwEDbXBtutXvaIXVcvAQoXdwvegOW6wr6GM1OlJ1K reed@rdmbp''
  ];
  system.stateVersion = "24.11"; # Did you read the comment?
}
