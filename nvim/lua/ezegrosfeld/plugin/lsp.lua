return {
    { 'williamboman/mason.nvim' },

    { 'williamboman/mason-lspconfig.nvim' },

    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        config = function()
            local lsp = require('lsp-zero').preset({})
            lsp.extend_lspconfig()

            lsp.on_attach(function(_, bufnr)
                -- see :help lsp-zero-keybindings
                -- to learn the available actions
                lsp.default_keymaps({ buffer = bufnr })
                local opts = { buffer = bufnr, remap = false }

                vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
                vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
                vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
                vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
                vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
                vim.keymap.set("n", "<leader>a", function() vim.lsp.buf.code_action() end, opts)
                vim.keymap.set("n", "<leader>rr", function() vim.lsp.buf.references() end, opts)
                vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
                vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
            end)

            lsp.set_sign_icons({
                error = 'E',
                warn = 'W',
                hint = 'H',
                info = 'I'
            })

            require('mason').setup({})
            require('mason-lspconfig').setup({
                ensure_installed = { 'lua_ls', 'rust_analyzer' },
                handlers = {
                    lsp.default_setup,
                    lua_ls = function()
                        require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
                    end,
                },
            })

            lsp.setup()

            local cmp = require('cmp')
            local cmp_action = require('lsp-zero').cmp_action()

            cmp.setup({
                mapping = {
                    -- `Enter` key to confirm completion
                    ['<CR>'] = cmp.mapping.confirm({ select = false }),

                    -- Ctrl+Space to trigger completion menu
                    ['<C-Space>'] = cmp.mapping.complete(),

                    -- Navigate between snippet placeholder
                    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
                    ['<C-b>'] = cmp_action.luasnip_jump_backward(),
                }
            })
        end,
    },

    { 'neovim/nvim-lspconfig' },

    { 'hrsh7th/cmp-nvim-lsp' },

    { 'hrsh7th/nvim-cmp' },

    { 'L3MON4D3/LuaSnip' }
}
