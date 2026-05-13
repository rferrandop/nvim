return {
    "nvim-telescope/telescope.nvim",
    tag = "v0.2.1",
    dependencies = {
        "nvim-lua/plenary.nvim"
    },
    config = function()
        local actions = require('telescope.actions')
        require('telescope').setup({
            defaults = {
                mappings = {
                    i = {
                        ["<esc>"] = actions.close,
                    },
                },
            },

        })
    end,
    keys = function()
        -- Helper function to detect project root
        local function find_project_root()
            local markers = {
                -- Version control
                ".git",
                -- JavaScript/TypeScript
                "package.json",
                "tsconfig.json",
                "jsconfig.json",
                -- Python
                "pyproject.toml",
                "setup.py",
                "requirements.txt",
                -- Rust
                "Cargo.toml",
                -- Go
                "go.mod",
                -- Java
                "pom.xml",
                "build.gradle",
                "settings.gradle",
                -- Ruby
                "Gemfile",
                -- PHP
                "composer.json",
                -- Generic
                ".projectile",
                ".root",
            }

            local current_file = vim.fn.expand("%:p:h")
            local root = vim.fn.getcwd()

            -- Start from current file directory and walk up
            local path = current_file
            for _ = 1, 20 do -- Limit depth to prevent infinite loop
                for _, marker in ipairs(markers) do
                    if vim.fn.isdirectory(path .. "/" .. marker) == 1 or vim.fn.filereadable(path .. "/" .. marker) == 1 then
                        return path
                    end
                end
                local parent = vim.fn.fnamemodify(path, ":h")
                if parent == path then
                    break
                end
                path = parent
            end

            return root
        end

        -- Helper function to detect language patterns based on project
        local function get_language_patterns()
            local root = find_project_root()
            local patterns = {}

            -- Check for project markers and return relevant patterns
            if vim.fn.filereadable(root .. "/package.json") == 1 then
                patterns = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.json", "*.css", "*.html" }
            elseif vim.fn.filereadable(root .. "/Cargo.toml") == 1 then
                patterns = { "*.rs", "*.toml" }
            elseif vim.fn.filereadable(root .. "/go.mod") == 1 then
                patterns = { "*.go", "*.mod", "*.sum" }
            elseif vim.fn.filereadable(root .. "/pom.xml") == 1 or vim.fn.filereadable(root .. "/build.gradle") == 1 then
                patterns = { "*.java", "*.xml", "*.gradle", "*.properties", "*.yaml", "*.yml" }
            elseif vim.fn.filereadable(root .. "/pyproject.toml") == 1 or vim.fn.filereadable(root .. "/setup.py") == 1 then
                patterns = { "*.py", "*.toml", "*.txt", "*.cfg" }
            elseif vim.fn.filereadable(root .. "/Gemfile") == 1 then
                patterns = { "*.rb", "*.rake", "*.gemspec" }
            elseif vim.fn.filereadable(root .. "/composer.json") == 1 then
                patterns = { "*.php", "*.json" }
            elseif vim.fn.filereadable(root .. "/flake.nix") == 1 then
                patterns = { "*.nix", "*.lock" }
            end

            return patterns, root
        end

        return {
            {
                "<C-g>",
                function()
                    local t = require('telescope.builtin')
                    t.live_grep()
                end,
                desc = "Live Grep",
            },
            {
                "<C-f>",
                function()
                    local t = require('telescope.builtin')
                    local opts = {
                        find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" }
                    }

                    local is_git = vim.fn.system("git rev-parse --is-inside-work-tree") == "true\n"

                    if is_git then
                        t.git_files()
                    else
                        t.find_files(opts)
                    end
                end,
                desc = "Find all files"
            },
            -- Disabled: Old LSP-based file finder
            -- {
            --     "<C-o>",
            --     function()
            --         local t = require('telescope.builtin')
            --         local lsp_ft = {
            --             jdtls = "*.java",
            --             lua_ls = "*.lua",
            --         }
            --
            --         local active_lsp = nil
            --         for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
            --             if lsp_ft[client.name] then
            --                 active_lsp = lsp_ft[client.name]
            --                 break -- Stop at the first match
            --             end
            --         end
            --
            --         local is_git = vim.fn.system("git rev-parse --is-inside-work-tree") == "true\n"
            --         local find = { "rg", "--files", "--hidden", "--glob", "!.git/*" }
            --
            --         if active_lsp then
            --             table.insert(find, "--glob")
            --             table.insert(find, active_lsp)
            --         end
            --
            --         local opts = {}
            --         if is_git and not active_lsp then
            --             t.git_files()
            --         else
            --             opts.find_command = find
            --             t.find_files(opts)
            --         end
            --     end,
            --     desc = "Find Files (git)"
            -- },
            {
                "<C-o>",
                function()
                    local t = require('telescope.builtin')
                    local patterns, root = get_language_patterns()

                    local find = { "rg", "--files", "--hidden", "--glob", "!.git/*", "--glob", "!node_modules/*", "--glob", "!target/*", "--glob", "!dist/*", "--glob", "!build/*" }

                    if #patterns > 0 then
                        -- Add language-specific patterns
                        for _, pattern in ipairs(patterns) do
                            table.insert(find, "--glob")
                            table.insert(find, pattern)
                        end
                    end

                    local opts = {
                        find_command = find,
                        cwd = root,
                        prompt_title = "Project Files (" .. vim.fn.fnamemodify(root, ":t") .. ")",
                    }

                    t.find_files(opts)
                end,
                desc = "Find Files (Project Scope)"
            },
        }
    end,
}
