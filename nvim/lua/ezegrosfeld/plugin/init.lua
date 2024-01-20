return {
    'nvim-lua/plenary.nvim',

    {
        'rebelot/kanagawa.nvim',
        config = function()
            vim.cmd.colorscheme("kanagawa")
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
        opts = {},
    }
}
