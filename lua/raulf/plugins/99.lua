return {
    "ThePrimeagen/99",
    config = function()
        local _99 = require("99")
        _99.setup({
            show_in_flight_requests = true,
            model = "github-copilot/claude-opus-4.6",
            logger = {
                level = _99.DEBUG,
                path = "/tmp/99.debug",
                print_on_error = true,
            },
            md_files = {
                "AGENTS.md",
            },
            completion = {
                source = "native",
            },
        })

        vim.keymap.set("n", "<leader>9s", function()
            _99.search()
        end, { desc = "AI search" })

        vim.keymap.set("v", "<leader>9vv", function()
            _99.visual()
        end, { desc = "AI visual" })

        vim.keymap.set("v", "<leader>9vp", function()
            _99.visual_prompt()
        end, { desc = "AI visual prompt" })

        vim.keymap.set("n", "<leader>9x", function()
            _99.stop_all_requests()
        end, { desc = "AI stop all requests" })

        vim.keymap.set("n", "<leader>9i", function()
            _99.info()
        end, { desc = "AI info" })

        vim.keymap.set("n", "<leader>9l", function()
            _99.view_logs()
        end, { desc = "AI view logs" })

        vim.keymap.set("n", "<leader>9n", function()
            _99.next_request_logs()
        end, { desc = "AI next request logs" })

        vim.keymap.set("n", "<leader>9p", function()
            _99.prev_request_logs()
        end, { desc = "AI prev request logs" })
    end,
}
