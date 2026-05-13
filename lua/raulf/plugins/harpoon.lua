return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
        { "<leader>a", function() require("harpoon"):list():add() end,                                    desc = "Harpoon add file" },
        { "<C-e>",     function() local h = require("harpoon") h.ui:toggle_quick_menu(h:list()) end,     desc = "Harpoon menu" },
        { "<M-1>",     function() require("harpoon"):list():select(1) end,                                desc = "Harpoon file 1" },
        { "<M-2>",     function() require("harpoon"):list():select(2) end,                                desc = "Harpoon file 2" },
        { "<M-3>",     function() require("harpoon"):list():select(3) end,                                desc = "Harpoon file 3" },
        { "<M-4>",     function() require("harpoon"):list():select(4) end,                                desc = "Harpoon file 4" },
    },
    config = function()
        require("harpoon"):setup()
    end,
}
