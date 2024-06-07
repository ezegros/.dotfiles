return {
    'stevearc/conform.nvim',
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                lua = { "stylua" },
                go = { "gofmt" },
                rust = { "rustfmt" },

                javascript = { { "prettierd", "prettier" } },
                typescript = { { "prettier", "prettierd" } },
                yaml = { "prettier", "prettierd" },

                json = { "jq" },
            },

            format_on_save = {
                lsp_fallback = true,
            },
        })
    end
}
