return {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        opts = {},
        config = function()
            vim.cmd("colorscheme tokyonight")
        end,
    },
    {
        "nickkadutskyi/jb.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
        config = function()
            -- require("jb").setup({transparent = true})
            --vim.cmd("colorscheme jb")
        end,
    }
}
