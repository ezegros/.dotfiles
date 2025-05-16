return {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
        "neovim/nvim-lspconfig",
        "mason-org/mason.nvim",
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-vsnip",
        "hrsh7th/vim-vsnip",
    },
    opts = {
        ensure_installed = {
            "lua-language-server",
            "gopls",
            "rust-analyzer",
            "zig-language-server",
        },
    },
    config = function(_, _)
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        local on_attach = function(client, bufnr)
            vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
            if client.server_capabilities.inlayHintProvider then vim.lsp.inlay_hint.enable(true) end
        end

        vim.lsp.config("*", {
            capabilities = capabilities,
            on_attach = on_attach,
        })

        vim.lsp.config.lua_ls = {
            capabilities = capabilities,
            on_attach = on_attach,
            on_init = function(client)
                if client.workspace_folders then
                    local path = client.workspace_folders[1].name
                    if
                        path ~= vim.fn.stdpath("config")
                        and (vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc"))
                    then
                        return
                    end
                end
                client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
                    runtime = {
                        version = "LuaJIT",
                    },
                    workspace = {
                        checkThirdParty = false,
                        library = {
                            vim.env.VIMRUNTIME,
                            "${3rd}/luv/library",
                        },
                    },
                })
            end,
            settings = {
                Lua = {
                    telemetry = {
                        enable = false,
                    },
                },
            },
        }

        require("mason").setup()
        require("mason-lspconfig").setup()
    end,
}
