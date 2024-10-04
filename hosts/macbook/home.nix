{ config, pkgs, ... }:
{
  imports = [
    ../../home/desktop.nix
  ];

  home.packages = with pkgs; [
    d2
    plan9port
  ];

  services = {
    syncthing = {
      enable = true;
    };
  };
}
