{ config, pkgs, ... }:
{
  imports = [
    ../../home/desktop.nix
  ];

  home.packages = with pkgs; [
    d2
    plan9port
    gopass
    gopass-jsonapi
    sops
    age
  ];

  services = {
    syncthing = {
      enable = true;
    };
  };

  home.sessionPath = [
    "/usr/local/go/bin"
    "/Users/reed/.local/bin"
  ];
}
