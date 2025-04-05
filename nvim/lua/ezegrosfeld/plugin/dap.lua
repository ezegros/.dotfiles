return {
    { 'leoluz/nvim-dap-go',              opts = {} },

    'rcarriga/nvim-dap-ui',

    { 'theHamsta/nvim-dap-virtual-text', opts = {} },

    {
        'mfussenegger/nvim-dap',
        config = function()
            local dap = require('dap')
            local dapui = require('dapui')

            dapui.setup()

            dap.adapters.codelldb = {
                type = "executable",
                command = "codelldb", -- or if not in $PATH: "/absolute/path/to/codelldb"

                -- On windows you may have to uncomment this:
                -- detached = false,
            }

            dap.configurations.zig = {
                {
                    name = "Launch file",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                    end,
                    cwd = '${workspaceFolder}',
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

            vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
        end
    }
}
