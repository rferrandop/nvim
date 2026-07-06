return {
    {
        'echasnovski/mini.pairs',
        version = '*',
        config = function()
            require('mini.pairs').setup()
        end,
    },
    {
        'echasnovski/mini.surround',
        version = '*',
        config = function()
            require('mini.surround').setup()
        end,
    },
    {
        'echasnovski/mini.comment',
        version = '*',
        config = function()
            require('mini.comment').setup()
        end,
    },
    {
        'folke/todo-comments.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = {
            signs = true,
            sign_priority = 8,
            keywords = {
                FIX = { icon = ' ', color = 'error', alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' } },
                TODO = { icon = ' ', color = 'info' },
                HACK = { icon = ' ', color = 'warning' },
                WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
                PERF = { icon = ' ', color = 'warning', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
                NOTE = { icon = ' ', color = 'hint', alt = { 'INFO' } },
            },
            colors = {
                error = { 'DiagnosticError', 'ErrorMsg', '#DA6E6E' },
                warning = { 'DiagnosticWarn', 'WarningMsg', '#DADCA9' },
                info = { 'DiagnosticInfo', '#2BCC71' },
                hint = { 'DiagnosticHint', '#10B981' },
                default = { 'Identifier', '#7C3AED' },
            },
        },
        keys = {
            {
                ']t',
                function() require('todo-comments').jump_next() end,
                desc = 'Next todo comment',
            },
            {
                '[t',
                function() require('todo-comments').jump_prev() end,
                desc = 'Previous todo comment',
            },
            {
                '<leader>tl',
                function() require('todo-comments').list() end,
                desc = 'List all todos',
            },
            {
                '<leader>tt',
                ':TodoTelescope<CR>',
                desc = 'Find todos (telescope)',
            },
        },
    },
}
