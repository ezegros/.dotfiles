return {
    'nvim-lua/plenary.nvim',

    {
        'rebelot/kanagawa.nvim',
        config = function()
            vim.cmd.colorscheme("kanagawa")
            vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
            vim.api.nvim_set_hl(0, "NormalFoat", { bg = "none" })
        end
    },

    'github/copilot.vim',

    {
        'akinsho/flutter-tools.nvim',
        requires = {
            'nvim-lua/plenary.nvim',
            'stevearc/dressing.nvim', -- optional for vim.ui.select
        },
        opts = {}
    },

    {
        "j-hui/fidget.nvim",
        opts = {
            notification = {
                window = {
                    winblend = 0
                },
            },
        },
    }
}
