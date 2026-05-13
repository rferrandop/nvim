return {
    "stevearc/conform.nvim",
    priority = 600,
    event = { "BufWritePost" },
    opts = {
        formatters_by_ft = {
            javascript = { "prettierd", "prettier", stop_after_first = true },
            typescript = { "prettierd", "prettier", stop_after_first = true },
            nix = { "alejandra" },
            lua = { "stylua" },
            xml = { "xmlformatter" },
            yaml = { "yamlfmt" },
            ["yaml.github"] = { "yamlfmt" },
            http = { "kulala" },
        }
    },
    keys = {
        {
            mode = { "n", "v" },
            "<leader>cf",
            function()
                require("conform").format({
                    lsp_fallback = true,
                    async = true,
                    timeout_ms = 500,
                })
            end,
            desc = "Format buffer",
        },
    }
}
