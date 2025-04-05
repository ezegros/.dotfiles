return {
    'nvim-lualine/lualine.nvim',
    opts = {
        theme = 'everforest',
        options = {
            icons_enabled = false,
            globalstatus = true,
        },
        sections = {
            lualine_a = { 'mode' },
            lualine_b = { 'branch', 'diff', 'diagnostics' },
            lualine_c = { { 'filename', path = 1 } },
            lualine_x = { 'filetype' },
            lualine_y = { 'location' },
            lualine_z = {}
        }
    }
}
