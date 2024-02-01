return {
    'folke/trouble.nvim',

    opts = {
        icons = false
    },

    config = function()
        vim.keymap.set("n", "<leader>tt", function() require("trouble").open() end)
        vim.keymap.set("n", "<leader>tw", function() require("trouble").open("workspace_diagnostics") end)
        vim.keymap.set("n", "<leader>td", function() require("trouble").open("document_diagnostics") end)
        vim.keymap.set("n", "<leader>tq", function() require("trouble").open("quickfix") end)
    end
}
