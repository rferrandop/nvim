return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio", -- required by dap-ui
        },
        keys = {
            -- Start / stop
            { "<leader>dc", function() require("dap").continue() end,          desc = "DAP continue / start" },
            { "<leader>dq", function() require("dap").terminate() end,         desc = "DAP terminate" },
            { "<leader>dR", function() require("dap").restart() end,           desc = "DAP restart" },

            -- Stepping
            { "<leader>dn", function() require("dap").step_over() end,         desc = "DAP step over" },
            { "<leader>di", function() require("dap").step_into() end,         desc = "DAP step into" },
            { "<leader>do", function() require("dap").step_out() end,          desc = "DAP step out" },

            -- Breakpoints
            { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "DAP toggle breakpoint" },
            { "<leader>dB", function()
                require("dap").set_breakpoint(vim.fn.input("Condition: "))
            end, desc = "DAP conditional breakpoint" },
            { "<leader>dl", function()
                require("dap").set_breakpoint(nil, nil, vim.fn.input("Log message: "))
            end, desc = "DAP logpoint" },
            { "<leader>dC", function() require("dap").clear_breakpoints() end, desc = "DAP clear breakpoints" },

            -- Run to cursor
            { "<leader>dg", function() require("dap").run_to_cursor() end,     desc = "DAP run to cursor" },

            -- Exception breakpoints
            { "<leader>dx", function()
                local dap = require("dap")
                local session = dap.session()
                if not session then
                    vim.notify("No active DAP session", vim.log.levels.WARN)
                    return
                end
                vim.ui.select(
                    { "All Exceptions", "Uncaught Exceptions", "Clear" },
                    { prompt = "Exception breakpoints:" },
                    function(choice)
                        if not choice then return end
                        if choice == "Clear" then
                            session:set_exception_breakpoints({ filters = {} })
                        elseif choice == "All Exceptions" then
                            session:set_exception_breakpoints({ filters = { "caught", "uncaught" } })
                        elseif choice == "Uncaught Exceptions" then
                            session:set_exception_breakpoints({ filters = { "uncaught" } })
                        end
                        vim.notify("Exception breakpoints: " .. choice)
                    end
                )
            end, desc = "DAP exception breakpoints" },

            -- Inspection
            { "<leader>dh", function() require("dap.ui.widgets").hover() end,  desc = "DAP hover value" },
            { "<leader>dp", function() require("dap.ui.widgets").preview() end,desc = "DAP preview" },

            -- UI
            { "<leader>du", function() require("dapui").toggle() end,          desc = "DAP toggle UI" },
            { "<leader>de", function() require("dapui").eval() end,            desc = "DAP eval expression",  mode = { "n", "v" } },
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            -- Auto-load .vscode/launch.json from the project root.
            -- This picks up per-project debug configurations (env vars, args, profiles, etc.)
            -- Works with git worktrees: each worktree can have its own .vscode/launch.json
            local vscode = require("dap.ext.vscode")
            -- Extend type-to-filetypes mapping so launch.json "type": "java" works
            vscode.type_to_filetypes["java"] = { "java" }
            local launch_json = vim.fn.getcwd() .. "/.vscode/launch.json"
            if vim.fn.filereadable(launch_json) == 1 then
                vscode.load_launchjs(launch_json)
            end

            -- Auto open/close UI on session start/end
            dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
            dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
            dap.listeners.before.event_exited["dapui_config"]     = function() dapui.close() end

            -- Signs
            vim.fn.sign_define("DapBreakpoint",          { text = "●", texthl = "DiagnosticError" })
            vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
            vim.fn.sign_define("DapLogPoint",            { text = "◉", texthl = "DiagnosticInfo" })
            vim.fn.sign_define("DapStopped",             { text = "→", texthl = "DiagnosticOk",  linehl = "DapStoppedLine" })
            vim.fn.sign_define("DapBreakpointRejected",  { text = "○", texthl = "DiagnosticHint" })

            dapui.setup({
                icons = { expanded = "", collapsed = "", current_frame = "" },
                layouts = {
                    {
                        elements = {
                            { id = "scopes",      size = 0.40 },
                            { id = "breakpoints", size = 0.20 },
                            { id = "stacks",      size = 0.20 },
                            { id = "watches",     size = 0.20 },
                        },
                        size = 40,
                        position = "left",
                    },
                    {
                        elements = {
                            { id = "repl",    size = 0.5 },
                            { id = "console", size = 0.5 },
                        },
                        size = 12,
                        position = "bottom",
                    },
                },
            })
        end,
    },

}
