local opt = vim.opt
local g = vim.g

g.mapleader = " "

-- indentation
opt.smartindent = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.scrolloff = 1

-- visual style
opt.number = true
opt.relativenumber = true
vim.cmd.syntax("on")
-- opt.termguicolors = true
-- vim.cmd.colorscheme("mies")

-- search
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.lazyredraw = true

-- mouse
opt.mouse = "a"
