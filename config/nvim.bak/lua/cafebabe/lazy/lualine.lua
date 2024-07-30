return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup({
			sections = {
				lualine_c = {
					"filename",
					"navic",
				},
			},
			inactive_sections = {
				lualine_c = {},
			},
		})
	end,
}
