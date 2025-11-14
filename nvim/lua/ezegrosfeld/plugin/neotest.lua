return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "rouge8/neotest-rust",
        {
            "fredrikaverpil/neotest-golang",
            version = "*",
            build = function()
                vim.system({ "go", "install", "gotest.tools/gotestsum@latest" }):wait()
            end,
        },
        "leoluz/nvim-dap-go",
    },
    config = function()
        local neotest = require("neotest")
        neotest.setup({
            adapters = {
                require("neotest-rust"),
                require("neotest-golang")({
                    runner = "gotestsum",
                    dap = { justMyCode = false },
                }),
            }
        })

        vim.keymap.set("n", "<leader>tr", function()
            neotest.run.run({
                suite = false,
                testify = true,
            })
        end)

        vim.keymap.set("n", "<leader>tf", function()
            neotest.run.run(vim.fn.expand("%"))
        end)

        vim.keymap.set("n", "<leader>ts", function()
            neotest.run.run({
                suite = true,
                testify = true,
            })
        end)

        vim.keymap.set("n", "<leader>tv", function()
            neotest.summary.toggle()
        end)

        vim.keymap.set("n", "<leader>td", function()
            neotest.run.run({
                suite = false,
                testify = true,
                strategy = "dap",
            })
        end)
    end
}
