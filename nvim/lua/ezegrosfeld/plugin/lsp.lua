return {
    {
        'williamboman/mason.nvim',
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "neovim/nvim-lspconfig",
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
            "L3MON4D3/LuaSnip",
        },
        lazy = false,
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local mason = require("mason")
            local mason_lspconfig = require("mason-lspconfig")

            vim.api.nvim_create_autocmd("LspAttach", {
                desc = "Lsp Actions",
                callback = function(event)
                    local opts = { buffer = event.buf }

                    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
                    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
                    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
                    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
                    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
                    vim.keymap.set("n", "<leader>a", function() vim.lsp.buf.code_action() end, opts)
                    vim.keymap.set("n", "<leader>rr", function() vim.lsp.buf.references() end, opts)
                    vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
                    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
                end,
            })

            mason.setup({})
            mason_lspconfig.setup({
                ensure_installed = { 'lua_ls', 'rust_analyzer', 'tsserver', 'gopls' },
            })

            lspconfig.lua_ls.setup {
                on_attach = lspconfig.util.on_attach,
                capabilities = capabilities
            }

            lspconfig.rust_analyzer.setup {
                on_attach = lspconfig.util.on_attach,
                capabilities = capabilities
            }

            lspconfig.tsserver.setup {
                on_attach = lspconfig.util.on_attach,
                capabilities = capabilities
            }

            lspconfig.gopls.setup {
                on_attach = lspconfig.util.on_attach,
                capabilities = capabilities,
            }

            local cmp = require 'cmp'
            -- Set configuration for specific filetype.
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    ['<C-Space>'] = cmp.mapping.complete(),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                }, {
                    { name = 'buffer' },
                })
            })
            cmp.setup.filetype('gitcommit', {
                sources = cmp.config.sources({
                    { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
                }, {
                    { name = 'buffer' },
                })
            })
        end
    }
}
