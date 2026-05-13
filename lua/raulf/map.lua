local map = vim.keymap.set

vim.g.mapleader = " "


map({ "n", "i" }, "<C-s>", vim.cmd.write)

map("n", "<S-h>", ":bprevious<CR>")
map("n", "<S-l>", ":bnext<CR>")

map("n", "<leader>bd", ":bdelete<CR>")
