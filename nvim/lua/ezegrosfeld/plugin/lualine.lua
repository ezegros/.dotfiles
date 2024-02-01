return {
    'nvim-lualine/lualine.nvim',
    opts = {
        options = {
            icons_enabled = false,
        },
        sections = {
            lualine_a = {},
            lualine_b = { 'branch', 'diff', 'diagnostics' },
            lualine_c = { { 'filename', path = 1 } },
            lualine_x = { 'filetype' },
            lualine_y = { 'location' },
            lualine_z = {}
        },
    }
}
