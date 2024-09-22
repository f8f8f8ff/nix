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
	];

	extraPackages = with pkgs; [
		fzf
		ripgrep
		fd
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
