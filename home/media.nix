{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    ffmpeg
    imagemagick
    lame
  ];

  programs = {
    yt-dlp = {
      enable = true;
      package = pkgs.yt-dlp-light;
    };
  };
}
