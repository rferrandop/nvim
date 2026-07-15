return {
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            local function get_location()
                local ok, navic = pcall(require, 'nvim-navic')
                if not ok then return '' end
                return navic.get_location()
            end

            require('lualine').setup {
                options = {
                    theme = 'auto',
                    section_separators = { left = '', right = '' },
                    component_separators = { left = '', right = '' },
                },
                sections = {
                    lualine_a = { 'mode' },
                    lualine_b = { 'branch', 'diff' },
                    lualine_c = {
                        {
                            'filename',
                            path = 1,
                        },
                        {
                            'diagnostics',
                            sources = { 'nvim_diagnostic' },
                            symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
                        },
                    },
                    lualine_x = {
                        {
                            get_location,
                            padding = { left = 2, right = 1 },
                            separator = { right = '' },
                        },
                        'encoding',
                        'fileformat',
                        'filetype'
                    },
                    lualine_y = { 'progress' },
                    lualine_z = { 'location' },
                },
                -- The top bar (buffers/tabs) is owned by bufferline.nvim; keeping a
                -- lualine tabline here made both plugins fight over showtabline.
            }
        end
    },
    {
        'SmiteshP/nvim-navic',
        lazy = true,
        opts = {
            icons = {
                File          = " ",
                Module        = " ",
                Namespace     = " ",
                Package       = " ",
                Class         = " ",
                Method        = " ",
                Property      = " ",
                Field         = " ",
                Constructor   = " ",
                Enum          = " ",
                Interface     = " ",
                Function      = " ",
                Variable      = " ",
                Constant      = " ",
                String        = " ",
                Number        = " ",
                Boolean       = " ",
                Array         = " ",
                Object        = " ",
                Key           = " ",
                Null          = " ",
                EnumMember    = " ",
                Struct        = " ",
                Event         = " ",
                Operator      = " ",
                TypeParameter = " ",
            },
            highlight = true,
            lazy_update_context = true,
        },
    },
    {
        'akinsho/bufferline.nvim',
        version = "*",
        dependencies = 'nvim-tree/nvim-web-devicons',
        config = function()
            require('bufferline').setup {
                options = {
                    -- buffers, not tabs: you navigate buffers with <S-h>/<S-l>
                    mode = "buffers",
                    separator_style = "thin",
                    show_buffer_close_icons = true,
                    show_close_icon = false,
                    color_icons = true,
                    offsets = {
                        {
                            filetype = "neo-tree",
                            text = "File Explorer",
                            highlight = "Directory",
                            separator = true,
                        },
                    },
                    diagnostics = "nvim_lsp",
                    diagnostics_indicator = function(count, level)
                        local icon = level:match("error") and " " or " "
                        return "(" .. count .. ")" .. icon
                    end,
                },
            }
        end
    },
    {
        'lukas-reineke/indent-blankline.nvim',
        main = 'ibl',
        event = { 'BufReadPre', 'BufNewFile' },
        opts = {
            indent = { char = "▏" },
            scope = { enabled = true, show_start = true, show_end = true },
        },
    },
}
