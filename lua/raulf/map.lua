local map = vim.keymap.set

vim.g.mapleader = " "


map({ "n", "i" }, "<C-s>", vim.cmd.write)

-- Navegación entre splits
map("n", "<C-h>", "<C-w>h")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")

-- Navegación entre buffers
map("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer", silent = true })
map("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer", silent = true })

-- Gestión de buffers
map("n", "<leader>bd", function()
    require("mini.bufremove").delete(0, false)
end, { desc = "Delete buffer" })
map("n", "<leader>bo", ":%bd|e#|bd#<CR>", { desc = "Close other buffers", silent = true })

