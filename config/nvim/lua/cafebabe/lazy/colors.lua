function SetColors(color)
	color = color or "neofusion"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
	"diegoulloao/neofusion.nvim", 
	priority = 1000 , 
	config = true, 
	opts = {},
	config = function()
		require("neofusion").setup({
			transparent_mode = true
		})

		vim.cmd("colorscheme neofusion")
		SetColors()
	end
}
