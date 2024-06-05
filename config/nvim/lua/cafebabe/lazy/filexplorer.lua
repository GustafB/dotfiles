return {
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup({
				columns = { "icon" },
				keymaps = {
					["<C-h>"] = false,
					["<M-h>"] = "actions.select_split",
				},
				view_options = {
					show_hidden = true,
				},
			})

			-- Open parent directory in current window
			vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

			-- Open parent directory in floating window
			vim.keymap.set("n", "<space>-", require("oil").toggle_float)
		end,
	},
}
--
--
-- return {
-- 	"tamago324/lir.nvim",
-- 	dependencies = {
-- 		"nvim-lua/plenary.nvim",
-- 	},
-- 	config = function()
-- 		local actions = require("lir.actions")
-- 		local clipboard_actions = require("lir.clipboard.actions")
--
-- 		require("lir").setup({
-- 			show_hidden_files = true,
-- 			devicons = { enable = true },
-- 			mappings = {
-- 				["<cr>"] = actions.edit,
-- 				["<C-s>"] = actions.split,
-- 				["<C-v>"] = actions.vsplit,
-- 				["<C-t>"] = actions.tabedit,
-- 				["-"] = actions.up,
-- 				["q"] = actions.quit,
-- 				["K"] = actions.mkdir,
-- 				["N"] = actions.newfile,
-- 				["R"] = actions.rename,
-- 				["Y"] = actions.yank_path,
-- 				["."] = actions.toggle_show_hidden,
-- 				["D"] = actions.delete,
-- 				["C"] = clipboard_actions.copy,
-- 				["X"] = clipboard_actions.cut,
-- 				["P"] = clipboard_actions.paste,
-- 			},
-- 		})
--
-- 		vim.api.nvim_set_keymap(
-- 			"n",
-- 			"<leader>fv",
-- 			[[<Cmd>execute 'e ' .. expand('%:p:h')<CR>]],
-- 			{ noremap = true, desc = "Open File Explorer" }
-- 		)
-- 	end,
-- }
