vim.keymap.set("x", "<leader>p", [[so]])
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>ft", vim.lsp.buf.format)
