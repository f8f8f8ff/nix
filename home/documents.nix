{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    poppler_utils
    pandoc
    rename
  ];
}
