local map = vim.keymap.set

vim.g.mapleader = " "


map({ "n", "i" }, "<C-s>", vim.cmd.write)

map("n", "<S-h>", ":bprevious<CR>")
map("n", "<S-l>", ":bnext<CR>")

map("n", "<C-h>", "<C-w>h")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")

-- Delete the current buffer without wrecking the window layout (mini.bufremove
-- keeps splits/neo-tree open instead of closing the window and quitting nvim)
map("n", "<leader>bd", function()
    require("mini.bufremove").delete(0, false)
end, { desc = "Delete buffer" })
