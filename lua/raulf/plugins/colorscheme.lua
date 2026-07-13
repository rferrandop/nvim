return {
    -- {
    --     "folke/tokyonight.nvim",
    --     lazy = false,
    --     opts = {},
    --     config = function()
    --         vim.cmd("colorscheme tokyonight")
    --     end,
    -- },
    -- {
    --     "nickkadutskyi/jb.nvim",
    --     lazy = false,
    --     priority = 1000,
    --     opts = {},
    --     config = function()
    --         -- require("jb").setup({transparent = true})
    --         --vim.cmd("colorscheme jb")
    --     end,
    -- }
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = true,
        init = function()
            vim.o.background = "dark"
            vim.cmd("colorscheme gruvbox")
        end,
    },
}
