{ config, pkgs, ... }:

{
  imports = [
    ./git.nix
  ];

  home.packages = with pkgs; [
    nixfmt-rfc-style
    rclone
    sshfs
    fzf
  ];

  programs = {
    zsh = {
      enable = true;
      initExtra = ''
        export PS1='%~%% '
      '';
    };
    tmux = {
      enable = true;
      mouse = true;
      keyMode = "vi";
      escapeTime = 0;
      extraConfig = ''
        bind X kill-session
        bind R source-file ~/.tmux.conf \; display-message "config reloaded..."
        set -g set-titles on
        set -g set-titles-string "#{pane_current_path}/-#{pane_current_command}"
        set -g status-style fg=brightwhite,bg=black
        set -g status-right " %I:%M %d-%b-%y"
        bind-key c new-window -c "#{pane_current_path}"
        bind-key % split-window -h -c "#{pane_current_path}"
        bind-key '"' split-window -v -c "#{pane_current_path}"
      '';
    };
    direnv = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
    btop = {
      enable = true;
      settings = {
        theme_background = false;
        truecolor = false;
        vim_keys = true;
      };
    };
  };

  home.stateVersion = "24.05"; # Please read the comment before changing.
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
