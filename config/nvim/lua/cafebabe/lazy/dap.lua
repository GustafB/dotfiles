return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"leoluz/nvim-dap-go",
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"williamboman/mason.nvim",
		},
		config = function()
			local dap = require("dap")
			local ui = require("dapui")

			vim.fn.sign_define("DapBreakpoint", { text = "🟥", texthl = "", linehl = "", numhl = "" })
			vim.fn.sign_define("DapStopped", { text = "▶️", texthl = "", linehl = "", numhl = "" })

			require("dapui").setup()
			require("dap-go").setup()

			dap.configurations.go = {
				{

					type = "go",
					name = "Debug",
					request = "launch",
					showLog = false,
					program = "${workspaceFolder}",
				},
				{
					name = "Run Backend",
					type = "go",
					request = "launch",
					mode = "debug",
					program = "backend/cmd/gin/main.go",
					cwd = "${workspaceFolder}/backend",
					args = { "--debug331122", "--no-init", "--allowedorigins=https://localhost:5555" },
					buildFlags = "-tags DEBUG -race",
					preLaunchTask = "debug",
					env = {
						ELASTIC_HOST = "localhost",
					},
					exitAfterTaskReturns = false,
					debugAutoInterpretAllModules = false,
				},
			}

			dap.configurations.cpp = {
				{
					name = "Launch",
					type = "gdb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					args = { "${workspaceFolder}/test/factorial.pl0" },
					cwd = "${workspaceFolder}",
					stopAtBeginningOfMainSubprogram = false,
				},
			}

			local go_ls_debugger = vim.fn.exepath("dlv")
			if go_ls_debugger ~= "" then
				dap.adapters.go = {
					type = "executable",
					command = go_ls_debugger,
				}
			end

			local gdb_ls_debugger = "/usr/local/bin/gdb"
			if gdb_ls_debugger ~= "" then
				dap.adapters.gdb = {
					type = "executable",
					command = gdb_ls_debugger,
					args = { "-i", "dap" },
				}
			end

			--
			-- Eval var under cursor
			vim.keymap.set("n", "<space>?", function()
				ui.eval(nil, { enter = true })
			end)

			vim.keymap.set("n", "<leader>dc", function()
				dap.continue()
			end, { desc = "Run" })

			vim.keymap.set("n", "<leader>dn", function()
				dap.step_into()
			end, { desc = "Step Into" })

			vim.keymap.set("n", "<leader>do", function()
				dap.step_out()
			end, { desc = "Step Out" })

			vim.keymap.set("n", "<Leader>dt", function()
				dap.toggle_breakpoint()
			end, { desc = "Toggle breakpoint" })

			vim.keymap.set("n", "<Leader>dB", function()
				dap.set_breakpoint()
			end, { desc = "Set breakpoint" })

			vim.keymap.set("n", "<Leader>dr", function()
				dap.repl.open()
			end, { desc = "Open REPL" })
			vim.keymap.set("n", "<Leader>dl", function()
				dap.run_last()
			end, { desc = "Run Last" }) --

			dap.listeners.before.attach.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				ui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				ui.close()
			end
		end,
	},
}
