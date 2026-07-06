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
                    always_show_tabline = true,
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
                tabline = {
                    lualine_a = {
                        {
                            'buffers',
                            show_filename_only = false,
                            hide_filename_extension = false,
                            max_length = vim.o.columns * 2 / 3,
                            buffers_color = {
                                active = 'lualine_a_normal',
                                inactive = 'lualine_b_inactive',
                            },
                        },
                    },
                    lualine_z = { 'tabs' },
                },
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
                    mode = "tabs",
                    separator_style = "slant",
                    show_buffer_close_icons = true,
                    show_close_icon = false,
                    color_icons = true,
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
