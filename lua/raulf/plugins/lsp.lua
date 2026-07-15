return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
                ui = {
                    border = "rounded",
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗"
                    }
                }
            })
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            require("mason-lspconfig").setup({
                automatic_installation = false,
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
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

            -- Load friendly-snippets
            require("luasnip.loaders.from_vscode").lazy_load()
            
            -- Cargar postfix snippets para Java
            local luasnip = require("luasnip")
            local java_postfix = require("raulf.snippets.java-postfix")
            luasnip.add_snippets("java", java_postfix)

            -- Configurar servidores LSP
            lsp.config("nil_ls", {
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
            })

            lsp.config("ts_ls", {
                capabilities = capabilities,
            })

            lsp.config("lua_ls", {
                capabilities = capabilities,
                settings = {
                    Lua = {
                        runtime = { version = 'LuaJIT' },
                        workspace = {
                            checkThirdParty = false,
                            library = {
                                vim.env.VIMRUNTIME,
                            }
                        },
                    }
                }
            })

            -- Habilitar servidores
            lsp.enable("ts_ls")
            lsp.enable("lua_ls")
            lsp.enable("nil_ls")

            require("fidget").setup({})



            local cmp = require('cmp')
            local luasnip = require('luasnip')
            local cmp_select = { behavior = cmp.SelectBehavior.Select }

            -- Comparador personalizado para Java: prioriza métodos de la clase sobre heredados
            local function compare_java_members(entry1, entry2)
                local lsp1 = entry1.source.source.client
                local lsp2 = entry2.source.source.client
                
                -- Solo aplicar a jdtls
                if not lsp1 or not lsp2 or lsp1.name ~= "jdtls" or lsp2.name ~= "jdtls" then
                    return nil
                end

                local detail1 = entry1.completion_item.detail or ""
                local detail2 = entry2.completion_item.detail or ""

                -- Los métodos heredados de Object/primitivos suelen tener estos details
                local is_inherited1 = detail1:match("Object") or detail1:match("Enum") or detail1:match("Class<")
                local is_inherited2 = detail2:match("Object") or detail2:match("Enum") or detail2:match("Class<")

                if is_inherited1 and not is_inherited2 then
                    return false  -- entry2 gana (no heredado)
                elseif not is_inherited1 and is_inherited2 then
                    return true   -- entry1 gana (no heredado)
                end

                return nil  -- dejar que otros comparadores decidan
            end

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
                sorting = {
                    priority_weight = 2,
                    comparators = {
                        cmp.config.compare.offset,
                        cmp.config.compare.exact,
                        cmp.config.compare.score,
                        compare_java_members,  -- Comparador personalizado para Java
                        cmp.config.compare.recently_used,
                        -- Priorizar métodos de la clase sobre heredados (jdtls usa sortText)
                        cmp.config.compare.sort_text,
                        cmp.config.compare.locality,
                        cmp.config.compare.kind,
                        cmp.config.compare.length,
                        cmp.config.compare.order,
                    },
                },
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

                    local client = vim.lsp.get_client_by_id(event.data.client_id)

                    local ok, navic = pcall(require, 'nvim-navic')
                    if ok and client then
                        navic.attach(client, buf)
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
