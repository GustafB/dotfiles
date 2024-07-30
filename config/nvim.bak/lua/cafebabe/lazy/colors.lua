return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").load({
				style = "moon",
			})
		end,
	},
	{
		"olimorris/onedarkpro.nvim",
		priority = 999,
	},
	{ "catppuccin/nvim", name = "catppuccin", priority = 999 },
}
