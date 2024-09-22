{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "reed donaldson";
    userEmail = "reedhdonaldson@gmail.com";
  };
}
