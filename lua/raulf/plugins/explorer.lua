-- True when the current session looks like a Java project: either jdtls is
-- already attached, or the cwd sits under a Maven/Gradle root. Used to gate the
-- Java-specific `group_empty_dirs` (collapsing com/example/app package trees),
-- which is annoying in non-Java repos.
local function is_java_project()
    if #vim.lsp.get_clients({ name = "jdtls" }) > 0 then
        return true
    end
    local markers = {
        "pom.xml", "mvnw",
        "build.gradle", "build.gradle.kts", "settings.gradle", "settings.gradle.kts", "gradlew",
    }
    return vim.fs.root(vim.fn.getcwd(), markers) ~= nil
end

-- Flip `group_empty_dirs` on any live filesystem state and re-render. Used when
-- jdtls attaches *after* neo-tree was already opened (e.g. tree open, then a
-- .java buffer loaded).
local function set_group_empty_dirs(enabled)
    local ok, mgr = pcall(require, "neo-tree.sources.manager")
    if not ok then return end
    mgr._for_each_state("filesystem", function(state)
        state.group_empty_dirs = enabled
    end)
    -- keep the base config in sync so newly created tabs inherit the value too
    local nt_ok, nt = pcall(require, "neo-tree")
    if nt_ok and nt.config and nt.config.filesystem then
        nt.config.filesystem.group_empty_dirs = enabled
    end
    pcall(mgr.refresh, "filesystem")
end

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
            { "<leader>e",  "<cmd>Neotree toggle<cr>",           desc = "Toggle file explorer" },
            { "<leader>E",  "<cmd>Neotree reveal<cr>",           desc = "Reveal current file" },
            { "<leader>ge", "<cmd>Neotree float git_status<cr>", desc = "Git status (float)" },
        },
        init = function()
            -- When jdtls attaches after neo-tree is already up, turn on Java
            -- package grouping so it kicks in without reopening the tree.
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("neotree_java_grouping", { clear = true }),
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if client and client.name == "jdtls" then
                        set_group_empty_dirs(true)
                    end
                end,
            })
        end,
        opts = function()
            return {
                close_if_last_window = true,

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
                    },
                    modified = { symbol = "●" },
                    name = {
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
                    -- Only collapse deeply nested single-child dirs (e.g. com/example/app)
                    -- in Java projects, where packages otherwise expand into 5 levels of
                    -- single-entry folders. Off elsewhere so normal trees aren't grouped.
                    group_empty_dirs = is_java_project(),
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
            }
        end,
    },
}
