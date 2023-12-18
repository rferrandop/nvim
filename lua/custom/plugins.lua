local overrides = require("custom.configs.overrides")

local plugins = {

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end, -- Override to setup mason-lspconfig
  },

  -- override plugin configs
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "html-lsp",
        "jdtls",
        "java-debug-adapter",
        "java-test"
      }
    }
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
            ensure_installed = {
                "c", "lua", "java", "rust", "yaml"
            }
        }
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },

  -- Install a plugin
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },

  -- Nvim jdtls
  {
    "mfussenegger/nvim-jdtls"
  }
}

return plugins
