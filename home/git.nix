{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    gh
  ];
  programs.git = {
    enable = true;
    userName = "reed donaldson";
    userEmail = "reedhdonaldson@gmail.com";
  };
}
