{config, pkgs, ...}:
{
  imports = [
    ../../home/desktop.nix
  ];

  home.packages = with pkgs; [
    d2
  ];
}
