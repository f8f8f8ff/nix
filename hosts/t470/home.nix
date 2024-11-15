{ lib, config, pkgs, ... }:
{
  imports = [
    ../../home/desktop.nix
  ];

  home.packages =
    with pkgs;
    [
      gnupg
      gopass
      go-font
      dejavu_fonts
      corefonts
      vistafonts
    ];

  fonts.fontconfig.enable = true;

  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = "DejaVu Sans Mono:size=12";
      };
      colors = {
        foreground = "ffffff";
        background = "171717";
      };
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      fonts = {
        names = [ "DejaVu Sans Mono" ];
        style = "Book";
        size = 12.0;
      };
      modifier = "Mod4";
      terminal = "foot";
      input."type:keyboard" = {
        xkb_options = "caps:escape";
      };
      input."type:touchpad" = {
        click_method = "clickfinger";
        drag = "enabled";
        tap = "enabled";
        tap_button_map = "lrm";
        scroll_method = "two_finger";
      };
      keybindings = let
        modifier = config.wayland.windowManager.config.modifier;
      in lib.mkOptionDefault {
        "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +5%";
        "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
        "XF86AudioRaiseVolume" = "exec ${pkgs.alsa-utils}/bin/amixer set Master 5%+";
        "XF86AudioLowerVolume" = "exec ${pkgs.alsa-utils}/bin/amixer set Master 5%-";
        "XF86AudioMute" = "exec ${pkgs.alsa-utils}/bin/amixer set Master toggle";
      };
    };
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-esr;
  };
}
