local M = {}

function M.setup()
	require("nvim-biscuits").setup({
		cursor_line_only = true,
		show_on_start = true,
	})
end

return M
