return {
    'nvim-treesitter/nvim-treesitter',

    branch = "main",

    lazy = false,

    build = ":TSUpdate",

    init = function()
        require 'nvim-treesitter'.install { 'rust', 'javascript', 'zig', 'typescript', 'go', 'lua', 'c', 'gitcommit' }
        vim.api.nvim_create_autocmd('FileType', {
            pattern = { 'rust', 'javascript', 'zig', 'typescript', 'go', 'lua', 'c', 'gitcommit' },
            callback = function()
                vim.treesitter.start()
            end,
        })
    end,
}
