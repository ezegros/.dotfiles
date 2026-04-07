vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == "nvim-treesitter" and kind == "update" then
            if not ev.data.active then vim.cmd.packadd("nvim-treesitter") end
            vim.cmd("TSUpdate")
        end
    end,
})

vim.pack.add({
    "https://github.com/sainnhe/everforest",
})

vim.cmd.colorscheme("everforest")

vim.pack.add({
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/github/copilot.vim",
    "https://github.com/j-hui/fidget.nvim",
    "https://github.com/nvim-treesitter/nvim-treesitter-context",
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/stevearc/conform.nvim",
    "https://github.com/mfussenegger/nvim-dap",
    "https://github.com/rcarriga/nvim-dap-ui",
    "https://github.com/leoluz/nvim-dap-go",
    "https://github.com/theHamsta/nvim-dap-virtual-text",
    "https://github.com/tpope/vim-fugitive",
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/nvim-lualine/lualine.nvim",
    "https://github.com/nvim-neotest/neotest",
    "https://github.com/rouge8/neotest-rust",
    "https://github.com/fredrikaverpil/neotest-golang",
    "https://github.com/stevearc/oil.nvim",
    "https://github.com/folke/sidekick.nvim",
    "https://github.com/nvim-telescope/telescope.nvim",
    "https://github.com/akinsho/toggleterm.nvim",
    "https://github.com/folke/trouble.nvim",
    "https://github.com/antoinemadec/FixCursorHold.nvim",
    "https://github.com/nvim-neotest/nvim-nio",
})

-- Fidget
require("fidget").setup({})

-- Conform
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

-- DAP
local dap = require("dap")
local dapui = require("dapui")

dapui.setup()

dap.adapters.codelldb = {
    type = "executable",
    command = "codelldb",
}

dap.configurations.zig = {
    {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
    },
}

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

require("dap-go").setup({})

vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)

-- Treesitter
local ensure_installed = { "rust", "javascript", "zig", "typescript", "go", "lua", "c", "gitcommit" }
local already_installed = require("nvim-treesitter.config").get_installed()
local to_install = vim.iter(ensure_installed):filter(function(p) return not vim.tbl_contains(already_installed, p) end):totable()
if #to_install > 0 then
    require("nvim-treesitter").install(to_install)
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "rust", "javascript", "zig", "typescript", "go", "lua", "c", "gitcommit" },
    callback = function()
        vim.treesitter.start()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})

-- Fugitive
vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

local EzeGrosfeld_Fugitive = vim.api.nvim_create_augroup("EzeGrosfeld_Fugitive", {})

vim.api.nvim_create_autocmd("BufWinEnter", {
    group = EzeGrosfeld_Fugitive,
    pattern = "*",
    callback = function()
        if vim.bo.ft ~= "fugitive" then
            return
        end

        local bufnr = vim.api.nvim_get_current_buf()
        local opts = { buffer = bufnr, remap = false }
        vim.keymap.set("n", "<leader>p", ":Git push ", opts)
        vim.keymap.set("n", "<leader>P", ":Git pull --rebase ", opts)
        vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts)
    end,
})

vim.keymap.set("n", "gu", "<cmd>diffget //2<cr>")
vim.keymap.set("n", "gh", "<cmd>diffget //3<cr>")

-- Lualine
require("lualine").setup({
    theme = "everforest",
    options = {
        icons_enabled = false,
        globalstatus = true,
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "filetype" },
        lualine_y = { "location" },
        lualine_z = {},
    },
})

vim.lsp.config.lua_ls = {
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
    end,
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                    "${3rd}/luv/library",
                },
            },
            telemetry = { enable = false },
        },
    },
}

vim.lsp.config.tailwindcss = {
    settings = {
        tailwindCSS = {
            classFunctions = { "cva", "cx" },
        },
    },
}

vim.lsp.enable({ "lua_ls", "gopls", "rust_analyzer", "zls" })

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, args.buf, {autotrigger = true})
    end
  end,
})

-- Neotest
local neotest = require("neotest")
neotest.setup({
    adapters = {
        require("neotest-rust"),
        require("neotest-golang")({
            runner = "gotestsum",
            dap = { justMyCode = false },
        }),
    },
})

vim.keymap.set("n", "<leader>tr", function()
    neotest.run.run({
        suite = false,
        testify = true,
    })
end)

vim.keymap.set("n", "<leader>tf", function()
    neotest.run.run(vim.fn.expand("%"))
end)

vim.keymap.set("n", "<leader>ts", function()
    neotest.run.run({
        suite = true,
        testify = true,
    })
end)

vim.keymap.set("n", "<leader>tv", function()
    neotest.summary.toggle()
end)

vim.keymap.set("n", "<leader>td", function()
    neotest.run.run({
        suite = false,
        testify = true,
        strategy = "dap",
    })
end)

-- Oil
require("oil").setup({
    use_default_keymaps = false,
    keymaps = {
        ["<CR>"] = "actions.select",
        ["-"] = "actions.parent",
    },
    view_options = {
        show_hidden = true,
    },
})

-- Sidekick
require("sidekick").setup({
    nes = { enabled = false },
})

vim.keymap.set("n", "<tab>", function()
    if not require("sidekick").nes_jump_or_apply() then
        return "<Tab>"
    end
end, { expr = true, desc = "Goto/Apply Next Edit Suggestion" })

vim.keymap.set({ "n", "t", "i", "x" }, "<c-.>", function() require("sidekick.cli").toggle() end, { desc = "Sidekick Toggle" })
vim.keymap.set("n", "<leader>aa", function() require("sidekick.cli").toggle() end, { desc = "Sidekick Toggle CLI" })
vim.keymap.set("n", "<leader>as", function() require("sidekick.cli").select({ filter = { installed = true } }) end, { desc = "Select CLI" })
vim.keymap.set("n", "<leader>ad", function() require("sidekick.cli").close() end, { desc = "Detach a CLI Session" })
vim.keymap.set({ "x", "n" }, "<leader>at", function() require("sidekick.cli").send({ msg = "{this}" }) end, { desc = "Send This" })
vim.keymap.set("n", "<leader>af", function() require("sidekick.cli").send({ msg = "{file}" }) end, { desc = "Send File" })
vim.keymap.set("x", "<leader>av", function() require("sidekick.cli").send({ msg = "{selection}" }) end, { desc = "Send Visual Selection" })
vim.keymap.set({ "n", "x" }, "<leader>ap", function() require("sidekick.cli").prompt() end, { desc = "Sidekick Select Prompt" })
vim.keymap.set("n", "<leader>ac", function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end, { desc = "Sidekick Toggle Copilot" })
vim.keymap.set("n", "<leader>ao", function() require("sidekick.cli").toggle({ name = "opencode", focus = true }) end, { desc = "Sidekick Toggle Opencode" })

-- Telescope
require("telescope").setup()

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
vim.keymap.set("n", "<C-p>", builtin.git_files, {})
vim.keymap.set("n", "<leader>ps", function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set("n", "<leader>pws", function()
    local word = vim.fn.expand("<cword>")
    builtin.grep_string({ search = word })
end)
vim.keymap.set("n", "<leader>gr", builtin.lsp_references, {})

-- Toggleterm
require("toggleterm").setup({
    open_mapping = [[<C-\>]],
    shade_terminals = false,
})

-- Trouble
require("trouble").setup({})

vim.keymap.set("n", "<leader>tw", "<cmd>Trouble diagnostics toggle focus=true<cr>", { desc = "Diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>tt", "<cmd>Trouble diagnostics toggle filter.buf=0 focus=true<cr>", { desc = "Buffer Diagnostics (Trouble)" })
