return {
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            signs = {
                add          = { text = "▎" },
                change       = { text = "▎" },
                delete       = { text = "" },
                topdelete    = { text = "" },
                changedelete = { text = "▎" },
                untracked    = { text = "▎" },
            },
            signs_staged = {
                add          = { text = "▎" },
                change       = { text = "▎" },
                delete       = { text = "" },
                topdelete    = { text = "" },
                changedelete = { text = "▎" },
            },
            signs_staged_enable = true,
            attach_to_untracked = true,
            current_line_blame = false,
            on_attach = function(bufnr)
                local gs = require("gitsigns")
                local map = vim.keymap.set
                local opts = { buffer = bufnr, silent = true }

                -- Hunk navigation
                map("n", "]h", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "]c", bang = true })
                    else
                        gs.nav_hunk("next")
                    end
                end, vim.tbl_extend("force", opts, { desc = "Next hunk" }))

                map("n", "[h", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "[c", bang = true })
                    else
                        gs.nav_hunk("prev")
                    end
                end, vim.tbl_extend("force", opts, { desc = "Previous hunk" }))

                -- Staging
                map("n", "<leader>hs", gs.stage_hunk,
                    vim.tbl_extend("force", opts, { desc = "Stage hunk" }))
                map("n", "<leader>hr", gs.reset_hunk,
                    vim.tbl_extend("force", opts, { desc = "Reset hunk" }))
                map("v", "<leader>hs", function()
                    gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, vim.tbl_extend("force", opts, { desc = "Stage hunk (selection)" }))
                map("v", "<leader>hr", function()
                    gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, vim.tbl_extend("force", opts, { desc = "Reset hunk (selection)" }))
                map("n", "<leader>hS", gs.stage_buffer,
                    vim.tbl_extend("force", opts, { desc = "Stage buffer" }))
                map("n", "<leader>hR", gs.reset_buffer,
                    vim.tbl_extend("force", opts, { desc = "Reset buffer" }))
                map("n", "<leader>hu", gs.undo_stage_hunk,
                    vim.tbl_extend("force", opts, { desc = "Undo stage hunk" }))

                -- Preview / diff
                map("n", "<leader>hp", gs.preview_hunk,
                    vim.tbl_extend("force", opts, { desc = "Preview hunk" }))
                map("n", "<leader>hd", gs.diffthis,
                    vim.tbl_extend("force", opts, { desc = "Diff this file" }))
                map("n", "<leader>hD", function() gs.diffthis("~") end,
                    vim.tbl_extend("force", opts, { desc = "Diff against last commit" }))

                -- Blame
                map("n", "<leader>tb", gs.toggle_current_line_blame,
                    vim.tbl_extend("force", opts, { desc = "Toggle line blame" }))
                map("n", "<leader>tB", function() gs.blame_line({ full = true }) end,
                    vim.tbl_extend("force", opts, { desc = "Blame current line (full)" }))

                -- Text object: select hunk with ih
                map({ "o", "x" }, "ih", gs.select_hunk,
                    vim.tbl_extend("force", opts, { desc = "Select hunk" }))
            end,
        },
    },
    {
        "tpope/vim-fugitive",
        cmd = { "G", "Git", "Gdiffsplit", "Gread", "Gwrite", "Gclog", "GMove", "GDelete", "GBrowse" },
        keys = {
            { "<leader>gg", "<cmd>Git<cr>",               desc = "Git status" },
            { "<leader>gl", "<cmd>Git log --oneline<cr>", desc = "Git log" },
            { "<leader>gL", "<cmd>Gclog<cr>",             desc = "Git log (buffer)" },
            { "<leader>gd", "<cmd>Gdiffsplit<cr>",        desc = "Git diff split" },
            { "<leader>gD", "<cmd>Gdiffsplit HEAD~1<cr>", desc = "Git diff vs HEAD~1" },
            { "<leader>gq", "<cmd>diffoff | q<cr>",       desc = "Close diff" },
            { "<leader>gw", "<cmd>Gwrite<cr>",            desc = "Git add (current file)" },
            { "<leader>gr", "<cmd>Gread<cr>",             desc = "Git checkout (current file)" },
            { "<leader>gc", "<cmd>Git commit<cr>",        desc = "Git commit" },
            { "<leader>gp", "<cmd>Git push<cr>",          desc = "Git push" },
            { "<leader>gf", "<cmd>Git push --force-with-lease<cr>", desc = "Git push --force-with-lease" },
            { "<leader>gP", "<cmd>Git pull<cr>",          desc = "Git pull" },
            { "<leader>gb", "<cmd>Git blame<cr>",         desc = "Git blame" },
        },
    },
}
