{ config, pkgs, lib, ... }:

let
  fromGitHub = rev: ref: repo: pkgs.vimUtils.buildVimPlugin {
    pname = "${lib.strings.sanitizeDerivationName repo}";
    version = ref;
    src = builtins.fetchGit {
      url = "https://github.com/${repo}.git";
      ref = ref;
      rev = rev;
    };
  };
in
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
      (fromGitHub "9a96579f800d709f0d1d7cc0f0eece9cf13af815" "main" "jaredgorski/Mies.vim")

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
      nil # nix ls
      gopls
      clang-tools
    ];

    extraConfig = ''
      :luafile ~/.config/nvim/lua/init.lua
    '';
  };

  xdg.configFile.nvim = {
    source = ./config;
    recursive = true;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
