return {
    'nvim-lua/plenary.nvim',

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
    },

    'nvim-treesitter/nvim-treesitter-context',
}
