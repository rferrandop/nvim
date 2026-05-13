return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        keys = {
            { "<leader>e",  "<cmd>Neotree toggle<cr>",                desc = "Toggle file explorer" },
            { "<leader>E",  "<cmd>Neotree reveal<cr>",                desc = "Reveal current file" },
            { "<leader>ge", "<cmd>Neotree float git_status<cr>",      desc = "Git status (float)" },
        },
        opts = {
            close_if_last_window = true,

            sources = { "filesystem", "git_status" },

            source_selector = {
                winbar = true,
                sources = {
                    { source = "filesystem", display_name = " Files" },
                    { source = "git_status", display_name = "󰊢 Git" },
                },
            },

            default_component_configs = {
                indent = {
                    indent_size = 2,
                    padding = 1,
                    -- expander renders the deep Java package trees much more cleanly
                    with_expanders = true,
                    expander_collapsed = "",
                    expander_expanded = "",
                    expander_highlight = "NeoTreeExpander",
                },
                icon = {
                    folder_closed = "",
                    folder_open = "",
                    folder_empty = "󰜌",
                },
                modified = { symbol = "●" },
                name = {
                    trailing_slash = false,
                    -- highlight the full package path differently so deeply nested
                    -- Java packages are easier to scan
                    use_git_status_colors = true,
                },
                git_status = {
                    symbols = {
                        added     = "",
                        modified  = "",
                        deleted   = "✖",
                        renamed   = "󰁕",
                        untracked = "",
                        ignored   = "",
                        unstaged  = "󰄱",
                        staged    = "",
                        conflict  = "",
                    },
                },
            },

            window = {
                position = "left",
                width = 38,
                mappings = {
                    ["<space>"] = "none", -- don't steal <leader>
                    ["o"]       = "open",
                    ["<cr>"]    = "open",
                    ["s"]       = "open_vsplit",
                    ["S"]       = "open_split",
                    ["t"]       = "open_tabnew",
                    ["z"]       = "close_all_nodes",
                    ["Z"]       = "expand_all_nodes",
                    ["a"]       = { "add", config = { show_path = "relative" } },
                    ["d"]       = "delete",
                    ["r"]       = "rename",
                    ["y"]       = "copy_to_clipboard",
                    ["x"]       = "cut_to_clipboard",
                    ["p"]       = "paste_from_clipboard",
                    ["c"]       = { "copy", config = { show_path = "relative" } },
                    ["m"]       = { "move", config = { show_path = "relative" } },
                    ["q"]       = "close_window",
                    ["R"]       = "refresh",
                    ["?"]       = "show_help",
                    ["<"]       = "prev_source",
                    [">"]       = "next_source",
                    ["i"]       = "show_file_details",
                },
            },

            filesystem = {
                -- Auto-collapse deeply nested single-child dirs (e.g. com/example/app)
                -- so Java packages don't expand into 5 levels of single-entry folders
                group_empty_dirs = true,
                follow_current_file = {
                    enabled = true,
                    leave_dirs_open = true,
                },
                use_libuv_file_watcher = true,
                filtered_items = {
                    visible = false,
                    hide_dotfiles = false,
                    hide_gitignored = true,
                    hide_by_name = {
                        ".git",
                        "node_modules",
                        ".devenv",
                    },
                    never_show = { ".DS_Store" },
                },
            },

            git_status = {
                window = { position = "float" },
            },
        },
    },
}
