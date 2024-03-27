return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
        "nvim-neotest/neotest-go",
        "rouge8/neotest-rust",
    },
    config = function()
        local neotest = require("neotest")
        neotest.setup({
            adapters = {
                require("neotest-rust"),
                require("neotest-go"),
            }
        })

        vim.keymap.set("n", "<leader>tr", function()
            neotest.run.run()
        end)

        vim.keymap.set("n", "<leader>tf", function()
            neotest.run.run(vim.fn.expand("%"))
        end)
    end
}
