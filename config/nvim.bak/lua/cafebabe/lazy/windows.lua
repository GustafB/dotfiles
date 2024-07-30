return {
	{
		"yorickpeterse/nvim-window",
		config = true,
	},
	{
		"echasnovski/mini.bufremove",
		config = true,
		keys = {
			{
				"<leader>bd",
				function()
					require("mini.bufremove").delete(0, false)
				end,
				desc = "Delete current buffer",
			},
		},
	},
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				show_close_icon = false,
				show_buffer_close_icons = false,
				truncate_names = false,
				indicator = { style = "underline" },
				close_command = function(bufnr)
					require("mini.bufremove").delete(bufnr, false)
				end,
				diagnostics = "nvim_lsp",
				diagnostics_update_in_insert = false,
			},
		},
		keys = {
			-- Buffer navigation.
			{ "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer" },
			{ "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
			{ "<leader>bc", "<cmd>BufferLinePickClose<cr>", desc = "Select a buffer to close" },
			{ "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", desc = "Close buffers to the left" },
			{ "<leader>bo", "<cmd>BufferLinePick<cr>", desc = "Select a buffer to open" },
			{ "<leader>br", "<cmd>BufferLineCloseRight<cr>", desc = "Close buffers to the right" },
		},
	},
}
