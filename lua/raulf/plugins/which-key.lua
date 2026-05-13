return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        preset = "modern",
        delay = 400,
        icons = {
            mappings = true,
        },
        spec = {
            -- Top-level groups
            { "<leader>b",  group = "buffer" },
            { "<leader>c",  group = "code" },
            { "<leader>d",  group = "debug" },
            { "<leader>g",  group = "git" },
            { "<leader>h",  group = "hunk" },
            { "<leader>j",  group = "java" },
            { "<leader>o",  group = "organize" },
            { "<leader>r",  group = "refactor" },
            { "<leader>t",  group = "toggle" },
            { "<leader>9",  group = "AI (99)" },

            -- Visual-mode groups
            { "<leader>h",  group = "hunk",    mode = "v" },
            { "<leader>r",  group = "refactor", mode = "v" },
            { "<leader>9",  group = "AI (99)",  mode = "v" },
            { "<leader>c",  group = "code",     mode = "v" },
        },
    },
}
