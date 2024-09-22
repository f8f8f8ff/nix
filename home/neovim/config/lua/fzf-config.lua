require('fzf-lua').setup({})

vim.keymap.set("n", "<leader>f", require('fzf-lua').files, {desc = "fzf files"})
vim.keymap.set("n", "<leader>b", require('fzf-lua').buffers, {desc = "fzf buffers"})
vim.keymap.set("n", "<leader>g", require('fzf-lua').live_grep, {desc = "fzf grep"})
