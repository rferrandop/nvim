return {
    {
        "mfussenegger/nvim-jdtls",
        ft = "java",
        dependencies = {
            "neovim/nvim-lspconfig",
            "mfussenegger/nvim-dap",
        },
        config = function()
            -- Prevent nvim-lspconfig's built-in lsp/jdtls.lua from auto-attaching.
            -- nvim-lspconfig ships a default jdtls config for Neovim 0.11+ that would
            -- run instead of nvim-jdtls if not explicitly disabled here.
            vim.lsp.config("jdtls", { enabled = false })

            local jdtls = require("jdtls")

            -- Register the JDKs installed via SDKMAN so jdtls compiles/runs each
            -- project against the JDK matching its source level (Eclipse execution
            -- environments). Discovered from ~/.sdkman/candidates/java/*; the one
            -- SDKMAN currently points to (the `current` symlink) is the default.
            local function java_runtimes()
                local sdk_java = vim.fn.expand("~/.sdkman/candidates/java")
                if vim.fn.isdirectory(sdk_java) == 0 then
                    return {}
                end
                -- Absolute path SDKMAN's `current` resolves to, to flag the default
                local current = vim.fn.resolve(sdk_java .. "/current")

                -- Multiple SDKMAN installs can map to the same execution
                -- environment (e.g. 17.0.9-tem and 17.0.5-zulu -> JavaSE-17), but
                -- jdtls needs unique names, so dedupe per EE (prefer `current`).
                local by_ee = {}
                for _, path in ipairs(vim.fn.glob(sdk_java .. "/*", false, true)) do
                    local name = vim.fn.fnamemodify(path, ":t")
                    local major = name ~= "current" and name:match("^(%d+)")
                    if major and vim.fn.isdirectory(path) == 1 then
                        major = tonumber(major)
                        local ee = major == 8 and "JavaSE-1.8" or ("JavaSE-" .. major)
                        if not by_ee[ee] or path == current then
                            by_ee[ee] = {
                                name = ee,
                                path = path,
                                default = (path == current) or nil,
                            }
                        end
                    end
                end

                local runtimes = {}
                for _, rt in pairs(by_ee) do
                    table.insert(runtimes, rt)
                end
                return runtimes
            end

            local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
            local root_dir = require("jdtls.setup").find_root(root_markers)
            if not root_dir then return end

            -- Derive project name from pom.xml artifactId if present,
            -- falling back to the root_dir folder name. This handles git worktrees
            -- and projects where pom.xml is nested inside the repo root.
            local project_name = vim.fn.fnamemodify(root_dir, ":t")
            local maven_root = require("jdtls.setup").find_root({ "pom.xml" })
            local pom = maven_root and (maven_root .. "/pom.xml") or nil
            if pom and vim.fn.filereadable(pom) == 1 then
                local in_parent = false
                for line in io.lines(pom) do
                    if line:match("<parent>") then in_parent = true end
                    if line:match("</parent>") then in_parent = false end
                    if not in_parent then
                        local id = line:match("<artifactId>([^<]+)</artifactId>")
                        if id then
                            project_name = id
                            break
                        end
                    end
                end
            end
            -- Isolate the workspace per checkout: multiple git worktrees of the
            -- same project share the same artifactId/folder name, so keying the
            -- workspace only on project_name would make them fight over one
            -- jdtls .metadata dir (index corruption, "workspace in use" errors).
            -- Appending a short hash of the absolute root_dir keeps names
            -- readable while giving every worktree its own isolated workspace.
            local workspace_id = project_name .. "-" .. vim.fn.sha256(root_dir):sub(1, 10)
            local workspace_dir = vim.fn.stdpath("data") .. "/jdtls/workspaces/" .. workspace_id

            -- Buscar jdtls en PATH y rutas comunes (macOS con Homebrew)
            local jdtls_bin = vim.fn.exepath("jdtls")
            if jdtls_bin == "" then
                -- Fallback: buscar en rutas típicas de Homebrew/Nix
                local fallback_paths = {
                    "/opt/homebrew/bin/jdtls",
                    "/usr/local/bin/jdtls",
                    "/nix/var/nix/profiles/default/bin/jdtls",
                    vim.fn.expand("~/.nix-profile/bin/jdtls"),
                }
                for _, path in ipairs(fallback_paths) do
                    if vim.fn.executable(path) == 1 then
                        jdtls_bin = path
                        break
                    end
                end
            end
            if jdtls_bin == "" then
                vim.notify(
                    "jdtls not found. Install: brew install jdtls",
                    vim.log.levels.ERROR
                )
                return
            end

            -- Lombok: check ~/.m2 for any lombok version, pick the highest
            local lombok_path = nil
            local m2_lombok = vim.fn.glob(
                vim.fn.expand("~") .. "/.m2/repository/org/projectlombok/lombok/*/lombok-*.jar", false, true
            )
            m2_lombok = vim.tbl_filter(function(p) return not p:match("%-sources%.jar$") end, m2_lombok)
            if #m2_lombok > 0 then
                table.sort(m2_lombok, function(a, b)
                    local function ver(s)
                        return s:match("lombok%-([%d%.]+)%.jar$")
                    end
                    local function parts(v)
                        local t = {}
                        for n in v:gmatch("%d+") do t[#t+1] = tonumber(n) end
                        return t
                    end
                    local pa, pb = parts(ver(a) or "0"), parts(ver(b) or "0")
                    for i = 1, math.max(#pa, #pb) do
                        local x, y = pa[i] or 0, pb[i] or 0
                        if x ~= y then return x < y end
                    end
                    return false
                end)
                lombok_path = m2_lombok[#m2_lombok]
            end
            if not lombok_path then
                for _, candidate in ipairs({ root_dir .. "/.lombok/lombok.jar", root_dir .. "/lombok.jar" }) do
                    if vim.fn.filereadable(candidate) == 1 then
                        lombok_path = candidate
                        break
                    end
                end
            end

            local cmd = { jdtls_bin, "-data", workspace_dir }
            if lombok_path then
                table.insert(cmd, "--jvm-arg=-javaagent:" .. lombok_path)
            end

            -- Debug bundle: try env var first (set in default.nix), fall back to Nix store path
            local bundles = {}
            local debug_ext = vim.env.JAVA_DEBUG_EXTENSION
            if debug_ext and debug_ext ~= "" then
                vim.list_extend(bundles, vim.fn.glob(
                    debug_ext .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", false, true
                ))
            end
            if #bundles == 0 then
                vim.list_extend(bundles, vim.fn.glob(
                    "/nix/store/*-vscode-extension-vscjava-vscode-java-debug-*/share/vscode/extensions/vscjava.vscode-java-debug/server/com.microsoft.java.debug.plugin-*.jar",
                    false, true
                ))
            end

            -- Test bundle: java-test extension (set in default.nix)
            local test_ext = vim.env.JAVA_TEST_EXTENSION
            if test_ext and test_ext ~= "" then
                local test_plugin = vim.fn.glob(
                    test_ext .. "/share/vscode/extensions/vscjava.vscode-java-test/server/com.microsoft.java.test.plugin-*.jar",
                    false, true
                )
                vim.list_extend(bundles, test_plugin)
                -- Also load all runtime jars needed by the test runner
                local test_jars = vim.fn.glob(
                    test_ext .. "/share/vscode/extensions/vscjava.vscode-java-test/server/*.jar",
                    false, true
                )
                for _, jar in ipairs(test_jars) do
                    if not jar:match("com.microsoft.java.test.plugin") and not vim.tbl_contains(bundles, jar) then
                        table.insert(bundles, jar)
                    end
                end
            end

            -- Spring Boot jdtls extension jars
            local spring_ok, spring_boot = pcall(require, "spring_boot")
            if spring_ok then
                vim.list_extend(bundles, spring_boot.java_extensions())
            end

            local config = {
                cmd = cmd,
                root_dir = root_dir,
                capabilities = require("cmp_nvim_lsp").default_capabilities(),
                init_options = {
                    bundles = bundles,
                },

                settings = {
                    java = {
                        codeGeneration = {
                            toString = {
                                template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
                            },
                            hashCodeEquals = { useJava7Objects = true },
                            useBlocks = true,
                        },

                        completion = {
                            favoriteStaticMembers = {
                                "org.junit.Assert.*",
                                "org.junit.Assume.*",
                                "org.junit.jupiter.api.Assertions.*",
                                "org.junit.jupiter.api.Assumptions.*",
                                "org.junit.jupiter.api.DynamicContainer.*",
                                "org.junit.jupiter.api.DynamicTest.*",
                                "org.mockito.Mockito.*",
                                "org.mockito.ArgumentMatchers.*",
                                "org.mockito.Answers.*",
                            },
                            filteredTypes = {
                                "com.sun.*",
                                "io.micrometer.shaded.*",
                                "java.awt.*",
                                "jdk.*",
                                "sun.*",
                            },
                            importOrder = { "java", "javax", "jakarta", "org", "com" },
                            guessMethodArguments = true,
                            overwrite = true,
                            -- Mostrar primero completions de la clase actual
                            matchCase = "firstLetter",
                            -- Habilitar postfix completions (.for, .if, etc)
                            postfix = { enabled = true },
                            -- Máximos resultados (evita mostrar todo Object/Enum)
                            maxResults = 50,
                        },

                        saveActions = { organizeImports = true },

                        format = {
                            enabled = true,
                            settings = { profile = "GoogleStyle" },
                        },

                        inlayHints = {
                            parameterNames = {
                                enabled = "all",
                                exclusions = {},
                            },
                        },

                        import = {
                            exclusions = {
                                "**/.devenv/**",
                                "**/node_modules/**",
                                "**/.metadata/**",
                                "**/build/**",
                                "**/generated/**",
                                "**/tmp/**",
                            },
                            gradle = { enabled = true },
                            maven  = { enabled = true },
                        },

                        project = {
                            resourceFilters = {
                                "\\.devenv", "node_modules", "\\.git",
                                "build", "generated", "tmp",
                            },
                        },

                        signatureHelp            = { enabled = true },
                        referencesCodeLens       = { enabled = true },
                        implementationsCodeLens  = { enabled = true },
                        contentProvider          = { preferred = "fernflower" },

                        sources = {
                            organizeImports = {
                                starThreshold = 9999,
                                staticStarThreshold = 9999,
                            },
                        },

                        configuration = {
                            updateBuildConfiguration = "automatic",
                            runtimes = java_runtimes(),
                        },
                        eclipse       = { downloadSources = true },
                        maven         = { downloadSources = true, updateSnapshots = false },
                    },
                },

                on_attach = function(client, bufnr)
                    if #bundles > 0 then
                        jdtls.setup_dap({ hotcodereplace = "auto" })
                    end

                    local map = vim.keymap.set
                    local opts = { buffer = bufnr, silent = true }

                    map("n", "<leader>oi", jdtls.organize_imports,
                        vim.tbl_extend("force", opts, { desc = "Organize imports" }))

                    map("n", "<leader>js", function()
                        vim.lsp.buf.execute_command({
                            command = "java.project.updateSourceAttachment",
                            arguments = { vim.uri_from_bufnr(bufnr) },
                        })
                    end, vim.tbl_extend("force", opts, { desc = "Download sources" }))

                    map("n", "<leader>rv", function() jdtls.extract_variable() end,
                        vim.tbl_extend("force", opts, { desc = "Extract variable" }))
                    map("v", "<leader>rv", function() jdtls.extract_variable(true) end,
                        vim.tbl_extend("force", opts, { desc = "Extract variable (selection)" }))

                    map("n", "<leader>rc", function() jdtls.extract_constant() end,
                        vim.tbl_extend("force", opts, { desc = "Extract constant" }))
                    map("v", "<leader>rc", function() jdtls.extract_constant(true) end,
                        vim.tbl_extend("force", opts, { desc = "Extract constant (selection)" }))

                    map("v", "<leader>rm", function() jdtls.extract_method(true) end,
                        vim.tbl_extend("force", opts, { desc = "Extract method (selection)" }))

                    -- Test runner
                    map("n", "<leader>jt", jdtls.test_nearest_method,
                        vim.tbl_extend("force", opts, { desc = "Test nearest method" }))
                    map("n", "<leader>jT", jdtls.test_class,
                        vim.tbl_extend("force", opts, { desc = "Test class" }))
                    map("n", "<leader>jp", jdtls.pick_test,
                        vim.tbl_extend("force", opts, { desc = "Pick test" }))

                    -- Debug: launch Spring Boot / main class
                    map("n", "<leader>jd", function()
                        local dap = require("dap")
                        local main_configs = jdtls.fetch_main_configs()
                        if not main_configs or #main_configs == 0 then
                            vim.notify("No main class found", vim.log.levels.WARN)
                            return
                        end
                        if #main_configs == 1 then
                            dap.run(main_configs[1])
                        else
                            vim.ui.select(main_configs, {
                                prompt = "Select main class:",
                                format_item = function(config) return config.mainClass or config.name end,
                            }, function(config)
                                if config then dap.run(config) end
                            end)
                        end
                    end, vim.tbl_extend("force", opts, { desc = "Debug main class" }))

                    -- Code generation helpers
                    local function java_action(action_title)
                        return function()
                            vim.lsp.buf.code_action({
                                apply = true,
                                filter = function(a) return a.title:find(action_title, 1, true) ~= nil end,
                            })
                        end
                    end

                    map("n", "<leader>jc", java_action("Generate Constructors"),
                        vim.tbl_extend("force", opts, { desc = "Generate constructor" }))
                    map("n", "<leader>jg", function()
                        vim.ui.select(
                            { "Getters", "Setters", "Getters and Setters" },
                            { prompt = "Generate:" },
                            function(choice)
                                if not choice then return end
                                if choice == "Getters" then
                                    java_action("Generate Getters")()
                                elseif choice == "Setters" then
                                    java_action("Generate Setters")()
                                else
                                    java_action("Generate Getters and Setters")()
                                end
                            end
                        )
                    end, vim.tbl_extend("force", opts, { desc = "Generate getters/setters" }))
                    map("n", "<leader>je", java_action("Generate hashCode"),
                        vim.tbl_extend("force", opts, { desc = "Generate equals & hashCode" }))
                    map("n", "<leader>jS", java_action("Generate toString"),
                        vim.tbl_extend("force", opts, { desc = "Generate toString" }))
                    map("n", "<leader>jD", java_action("Generate Delegate"),
                        vim.tbl_extend("force", opts, { desc = "Generate delegate methods" }))

                    if vim.lsp.inlay_hint then
                        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                    end
                end,
            }

            vim.api.nvim_create_autocmd("BufEnter", {
                group = vim.api.nvim_create_augroup("jdtls_attach", { clear = true }),
                pattern = "*.java",
                callback = function()
                    jdtls.start_or_attach(config)
                end,
            })

            jdtls.start_or_attach(config)
        end,
    }
}
