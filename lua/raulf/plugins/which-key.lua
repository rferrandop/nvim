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
            -- Buffer operations
            { "<leader>b",  group = "buffer" },
            { "<leader>bd", desc = "Delete buffer" },

            -- Code operations
            { "<leader>c",  group = "code" },
            { "<leader>ca", desc = "Code actions" },
            { "<leader>cd", desc = "Diagnostics" },
            { "<leader>cf", desc = "Format" },

            -- Debugging
            { "<leader>d",  group = "debug" },
            { "<leader>dc", desc = "Continue/Start" },
            { "<leader>dq", desc = "Terminate" },
            { "<leader>dR", desc = "Restart" },
            { "<leader>dn", desc = "Step over" },
            { "<leader>di", desc = "Step into" },
            { "<leader>do", desc = "Step out" },
            { "<leader>db", desc = "Toggle breakpoint" },
            { "<leader>dB", desc = "Conditional BP" },
            { "<leader>dl", desc = "Log point" },
            { "<leader>dg", desc = "Run to cursor" },
            { "<leader>dx", desc = "Exception BP" },
            { "<leader>du", desc = "Toggle DAP UI" },
            { "<leader>de", desc = "Evaluate" },

            -- Git operations
            { "<leader>g",  group = "git" },
            { "<leader>gg", desc = "Git status" },
            { "<leader>gl", desc = "Git log" },
            { "<leader>gc", desc = "Git commit" },
            { "<leader>gp", desc = "Git push" },
            { "<leader>gP", desc = "Git pull" },

            -- Git hunks
            { "<leader>h",  group = "hunk" },
            { "<leader>hs", desc = "Stage hunk" },
            { "<leader>hr", desc = "Reset hunk" },
            { "<leader>hp", desc = "Preview hunk" },
            { "<leader>hd", desc = "Diff hunk" },

            -- Java
            { "<leader>j",  group = "java" },
            { "<leader>jt", desc = "Test method" },
            { "<leader>jd", desc = "Debug class" },
            { "<leader>jc", desc = "Constructor" },
            { "<leader>jg", desc = "Getters/Setters" },

            -- Organization & Refactoring
            { "<leader>o",  group = "oil/organize" },
            { "<leader>oi", desc = "Organize imports" },
            { "<leader>r",  group = "refactor" },
            { "<leader>rv", desc = "Extract variable" },
            { "<leader>rc", desc = "Extract constant" },
            { "<leader>rm", desc = "Extract method" },
            { "<leader>rn", desc = "Rename symbol" },

            -- Toggle & Search
            { "<leader>t",  group = "toggle/todo" },
            { "<leader>tb", desc = "Line blame" },
            { "<leader>tl", desc = "List todos" },
            { "<leader>tt", desc = "Find todos" },

            -- AI
            { "<leader>9",  group = "AI (99)" },
            { "<leader>9s", desc = "AI search" },
            { "<leader>9x", desc = "Stop AI" },

            -- File explorer
            { "<leader>e",  group = "explorer" },

            -- Harpoon
            { "<leader>a",  desc = "Harpoon add" },

            -- Visual mode groups
            { "<leader>h",  group = "hunk",    mode = "v" },
            { "<leader>r",  group = "refactor", mode = "v" },
            { "<leader>9",  group = "AI (99)",  mode = "v" },
            { "<leader>c",  group = "code",     mode = "v" },
        },
    },
}

