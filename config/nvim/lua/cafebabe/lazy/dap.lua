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

			require("dapui").setup()
			require("dap-go").setup()

			-- dap.configurations.go = {
			-- 	{
			--
			-- 		type = "go",
			-- 		name = "Debug",
			-- 		request = "launch",
			-- 		showLog = false,
			-- 		program = "${workspaceFolder}",
			-- 	},
			-- 	{
			-- 		name = "Run Backend",
			-- 		type = "go",
			-- 		request = "launch",
			-- 		mode = "debug",
			-- 		program = "backend/cmd/gin/main.go",
			-- 		cwd = "${workspaceFolder}/backend",
			-- 		args = { "--debug331122", "--no-init", "--allowedorigins=https://localhost:5555" },
			-- 		buildFlags = "-tags DEBUG -race",
			-- 		preLaunchTask = "debug",
			-- 		env = {
			-- 			ELASTIC_HOST = "localhost",
			-- 		},
			-- 		exitAfterTaskReturns = false,
			-- 		debugAutoInterpretAllModules = false,
			-- 	},
			-- }
			--
			-- --
			-- local go_ls_debugger = vim.fn.exepath("dlv")
			-- if go_ls_debugger ~= "" then
			-- 	dap.adapters.go = {
			-- 		type = "executable",
			-- 		command = go_ls_debugger,
			-- 	}
			-- end
			--
			-- Eval var under cursor
			vim.keymap.set("n", "<space>?", function()
				require("dapui").eval(nil, { enter = true })
			end)

			vim.keymap.set("n", "<leader>dc", function()
				dap.continue()
			end)
			-- vim.keymap.set("n", "<leader>d", function()
			-- 	dap.step_over()
			-- end)
			-- vim.keymap.set("n", "<F11>", function()
			-- 	dap.step_into()
			-- end)
			-- vim.keymap.set("n", "<F12>", function()
			-- 	dap.step_out()
			-- end)
			vim.keymap.set("n", "<Leader>dt", function()
				dap.toggle_breakpoint()
			end)
			vim.keymap.set("n", "<Leader>dB", function()
				dap.set_breakpoint()
			end)
			-- vim.keymap.set("n", "<Leader>lp", function()
			-- 	dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
			-- end)
			vim.keymap.set("n", "<Leader>dr", function()
				dap.repl.open()
			end)
			vim.keymap.set("n", "<Leader>dl", function()
				dap.run_last()
			end) --

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
