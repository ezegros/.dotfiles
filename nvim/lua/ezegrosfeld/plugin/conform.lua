return {
    'stevearc/conform.nvim',
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                lua = { "stylua" },
                go = { "gofmt" },
                rust = { "rustfmt" },
                json = { "jq" },
            },

            format_on_save = {
                lsp_fallback = true,
            },
        })
    end
}
