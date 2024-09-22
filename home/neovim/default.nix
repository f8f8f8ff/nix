{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      vim-sensible
      # syntax/detection/indentation for langs
      vim-nix

      # files
      vim-vinegar
      # fzf
      fzf-lua
      # detect tab style
      vim-sleuth
      # git
      vim-fugitive
      # theme
      papercolor-theme

      # lsp
      nvim-lspconfig

      # completion
      nvim-cmp
      cmp-nvim-lsp
      cmp-cmdline
      cmp-buffer
      cmp-path

      # snippet
      luasnip
    ];

    extraPackages = with pkgs; [
      fzf
      ripgrep
      fd

      lua-language-server
      # nix ls
      nil
    ];

    extraConfig = ''
      :luafile ~/.config/nvim/lua/init.lua
    '';
  };

  xdg.configFile.nvim = {
    source = ./config;
    recursive = true;
  };
}
