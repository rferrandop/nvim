return {
    {
        'stevearc/oil.nvim',
        opts = {
            default_file_explorer = false,
            skip_confirm_for_simple_edits = true,
            keymaps = {
                ["g?"] = "actions.show_help",
                ["<CR>"] = "actions.select",
                ["<C-s>"] = "actions.select_vsplit",
                ["<C-h>"] = "actions.select_split",
                ["<C-t>"] = "actions.select_tab",
                ["<C-p>"] = "actions.preview",
                ["<C-c>"] = "actions.close",
                ["<C-l>"] = "actions.refresh",
                ["-"] = "actions.parent",
                ["_"] = "actions.open_cwd",
                ["`"] = "actions.cd",
                ["~"] = "actions.tcd",
                ["gs"] = "actions.change_sort",
                ["gx"] = "actions.open_external",
                ["g."] = "actions.toggle_hidden",
                ["g\\"] = "actions.toggle_trash",
            },
            use_default_keymaps = false,
            view_options = {
                show_hidden = false,
                is_hidden_file = function(name, bufnr)
                    return vim.startswith(name, ".")
                end,
            },
        },
        keys = {
            {
                "<leader>o",
                function() require("oil").open() end,
                desc = "Open oil (file browser)",
            },
        },
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
}
