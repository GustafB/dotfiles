vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd({ "FileType", "BufEnter", "BufNewFile" }, {
	pattern = { "*.cpp", "*.hpp", "*.c", "*.h" },
	callback = function()
		vim.opt.cinoptions = "" -- clear C indent options
		vim.opt.cinoptions:append(":0") --case label at switch indentation level
		vim.opt.cinoptions:append("l1") --align with case label instead of statement on label line
		vim.opt.cinoptions:append("g0") --C++ scope declarations (public:, ...) without indentation
		vim.opt.cinoptions:append("e - 2")
		vim.opt.cinoptions:append("N-s") -- dont indent namespaces
		-- vim.opt.cinkeys:
	end,
})
