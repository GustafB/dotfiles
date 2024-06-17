local function SetColors(color)
	color = color or "tokyonight"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").load({
				style = "moon",
			})
			SetColors()
		end,
	},
	{
		"olimorris/onedarkpro.nvim",
		priority = 999,
	},
	{ "catppuccin/nvim", name = "catppuccin", priority = 999 },
}
