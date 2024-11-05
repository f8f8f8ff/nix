{ config, pkgs, ... }:
{
  imports = [
    ../../home/desktop.nix
  ];

  home.packages = with pkgs; [ ];

  services.syncthing = {
    enable = true;
    extraOptions = [
      "--gui-address=http://0.0.0.0:8384"
    ];
  };
}
