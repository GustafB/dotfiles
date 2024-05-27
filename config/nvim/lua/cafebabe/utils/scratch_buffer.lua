local M = {}

M.open_scratch_buffer = function()
	-- Prompt the user for a file extension
	local file_extension = vim.fn.input("File Extension: ")
	if file_extension == "" then
		return
	end

	-- Create a new file path in ~/.tmp with the given extension
	local tmp_dir = vim.fn.expand("~/.tmp")
	if vim.fn.isdirectory(tmp_dir) == 0 then
		vim.fn.mkdir(tmp_dir, "p")
	end
	local filename = string.format("%s/scratch_%s.%s", tmp_dir, os.date("%Y%m%d%H%M%S"), file_extension)

	-- Open the file in a new buffer
	vim.api.nvim_command("e " .. filename)


vim.keymap.set(
	"n",
	"<leader>dc",
	":lua require('utils.scratch_buffer').open_scratch_buffer()<CR>",
	{ noremap = true, silent = true }
)
end

return M
