return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/nvim-cmp",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
            "j-hui/fidget.nvim",
        },

        config = function()
            local lsp = vim.lsp
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            -- Load friendly-snippets (VS Code-style snippets for many languages)
            require("luasnip.loaders.from_vscode").lazy_load()

            lsp.config["nil_ls"] = {
                capabilities = capabilities,
                settings = {
                    ['nil'] = {
                        formatting = { command = { "alejandra" } }
                    }
                },
                on_attach = function(_, bufnr)
                    vim.bo[bufnr].tabstop = 2
                    vim.bo[bufnr].shiftwidth = 2
                end,
            }

            lsp.config["tsserver"] = {
                cmd = { 'typescript-language-server', '--stdio' },
                filetypes = { 'typescript' },
                root_dir = vim.fs.root(0, { 'package.json', '.git' }),
                capabilities = capabilities,
            }

            lsp.enable("tsserver")
            lsp.enable("nil_ls")

            require("fidget").setup({})

            local cmp = require('cmp')
            local luasnip = require('luasnip')
            local cmp_select = { behavior = cmp.SelectBehavior.Select }

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    -- Jump through snippet placeholders
                    ['<C-l>'] = cmp.mapping(function()
                        if luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        end
                    end, { 'i', 's' }),
                    ['<C-h>'] = cmp.mapping(function()
                        if luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        end
                    end, { 'i', 's' }),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp', max_item_count = 10 },
                    { name = 'luasnip',  max_item_count = 8 },
                    { name = 'path',     max_item_count = 5 },
                }, {
                    { name = 'buffer', max_item_count = 8 },
                }),
                pumheight = 6,
            })

            vim.diagnostic.config({
                signs = true,
                underline = true,
                update_in_insert = false,
                severity_sort = true,
                float = {
                    focusable = false,
                    style = "minimal",
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                },
            })

            -- LSP keymaps set buffer-locally on every LspAttach
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("raulf_lsp_keymaps", { clear = true }),
                callback = function(event)
                    local map = vim.keymap.set
                    local buf = event.buf
                    local opts = { buffer = buf, silent = true }

                    -- Setup navic if available
                    local ok, navic = pcall(require, 'nvim-navic')
                    if ok then
                        navic.attach(event.client, buf)
                    end

                    -- Navigation
                    map("n", "K",           vim.lsp.buf.hover,          vim.tbl_extend("force", opts, { desc = "Hover docs" }))
                    map("n", "gd",          vim.lsp.buf.definition,     vim.tbl_extend("force", opts, { desc = "Go to definition" }))
                    map("n", "gD",          vim.lsp.buf.declaration,    vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
                    map("n", "gi",          vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
                    map("n", "go",          vim.lsp.buf.type_definition,vim.tbl_extend("force", opts, { desc = "Go to type definition" }))
                    map("n", "gr",          vim.lsp.buf.references,     vim.tbl_extend("force", opts, { desc = "References" }))
                    map("n", "gs",          vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature help" }))

                    -- Actions
                    map("n", "<leader>rn",  vim.lsp.buf.rename,         vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
                    map("n", "<leader>ca",  vim.lsp.buf.code_action,    vim.tbl_extend("force", opts, { desc = "Code actions" }))
                    map("v", "<leader>ca",  vim.lsp.buf.code_action,    vim.tbl_extend("force", opts, { desc = "Code actions (range)" }))

                    -- Diagnostics
                    map("n", "<leader>cd",  vim.diagnostic.open_float,  vim.tbl_extend("force", opts, { desc = "Show diagnostic" }))
                    map("n", "[d",          vim.diagnostic.goto_prev,   vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
                    map("n", "]d",          vim.diagnostic.goto_next,   vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
                end,
            })
        end
    },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    }
}
