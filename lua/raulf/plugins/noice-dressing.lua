return {
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        opts = {
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
            },
            presets = {
                bottom_search = true,
                command_palette = true,
                long_message_to_split = true,
                inc_rename = false,
                lsp_doc_border = true,
            },
            routes = {
                {
                    filter = {
                        event = "msg_show",
                        any = {
                            { find = "%d+L, %d+B" },
                            { find = "; after #%d+" },
                            { find = "; before #%d+" },
                        },
                    },
                    view = "mini",
                },
            },
        },
    },
    {
        "stevearc/dressing.nvim",
        event = "VeryLazy",
        opts = {
            input = {
                enabled = true,
                default_prompt = "➤ ",
                prompt_align = "left",
                insert_only = true,
                start_in_insert = true,
                border = "rounded",
                prefer_width = 40,
                max_width = { 140, 0.9 },
                min_width = { 20, 0.2 },
                win_options = {
                    winblend = 10,
                    wrap = false,
                    list = false,
                    listchars = "extends:…,precedes:…",
                },
            },
            select = {
                enabled = true,
                backend = { "telescope", "builtin" },
                trim_prompt = true,
                builtin = {
                    border = "rounded",
                    relative = "editor",
                    max_width = { 80, 0.9 },
                    min_width = { 40, 0.2 },
                    max_height = { 16, 0.9 },
                    win_options = {
                        winblend = 10,
                    },
                },
            },
        },
    },
    {
        "rcarriga/nvim-notify",
        event = "VeryLazy",
        opts = {
            timeout = 3000,
            max_height = function()
                return math.floor(vim.o.lines * 0.75)
            end,
            max_width = function()
                return math.floor(vim.o.columns * 0.75)
            end,
        },
    },
}
