local export = {}

function export.lsp_on_attach(client, bufnr)
	-- In this case, we create a function that lets us more easily define mappings specific
	-- for LSP related items. It sets the mode, buffer and description for us each time.
	local map = function(keys, func, desc)
		local opts = { buffer = bufnr, desc = "LSP: " .. desc, noremap = true, silent = true }
		vim.keymap.set("n", keys, func, opts)
	end

	-- Jump to the definition of the word under your cursor.
	--  This is where a variable was first declared, or where a function is defined, etc.
	--  To jump back, press <C-t>.
	map("<leader>ld", require("telescope.builtin").lsp_definitions, "[G]oto [D]definition")

	-- Find references for the word under your cursor.
	map("<leader>lr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

	-- Jump to the implementation of the word under your cursor.
	--  Useful when your language has ways of declaring types without an actual implementation.
	map("<leader>li", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

	-- Jump to the type of the word under your cursor.
	--  Useful when you're not sure what type a variable is and you want to see
	--  the definition of its *type*, not where it was *defined*.
	map("<leader>lt", require("telescope.builtin").lsp_type_definitions, "Type [D]definition")

	-- Fuzzy find all the symbols in your current document.
	--  Symbols are things like variables, functions, types, etc.
	map("<leader>ls", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]symbols")

	-- Fuzzy find all the symbols in your current workspace
	--  Similar to document symbols, except searches over your whole project.
	map("<leader>lw", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]symbols")

	-- Rename the variable under your cursor
	--  Most Language Servers support renaming across files, etc.
	map("<leader>ln", vim.lsp.buf.rename, "[R]e[n]ame")

	-- Execute a code action, usually your cursor needs to be on top of an error
	-- or a suggestion from your LSP for this to activate.
	map("<leader>la", vim.lsp.buf.code_action, "[C]ode [A]ction")

	-- Opens a popup that displays documentation about the word under your cursor
	--  See `:help K` for why this keymap
	map("<leader>lk", vim.lsp.buf.hover, "Hover Documentation")

	-- WARN: This is not Goto Definition, this is Goto Declaration.
	--  For example, in C this would take you to the header
	map("<leader>lD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

	map("<leader>lf", function()
		require("conform").format({ async = true, lsp_fallback = true })
	end, "[L]SP [F]ormat Buffer")
	--
	-- vim.api.nvim_create_autocmd("BufWritePre", {
	-- 	pattern = "*",
	-- 	callback = function(args)
	-- 		require("conform").format({ bufnr = args.buf })
	-- 	end,
	-- })
	-- if client.supports_method("textDocument/formatting") then
	--     vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	--         group = vim.api.nvim_create_augroup("SharedLspFormatting", { clear = true }),
	--         pattern = "*",
	--         command = "lua vim.lsp.buf.format()",
	--         vim.lsp.buf.format()
	--     })
	-- end
end

export.cafebabe_lsp_auto = function(event)
	-- The following two autocommands are used to highlight references of the
	-- word under your cursor when your cursor rests there for a little while.
	--    See `:help CursorHold` for information about when this is executed
	--
	-- When you move your cursor, the highlights will be cleared (the second autocommand).
	local client = vim.lsp.get_client_by_id(event.data.client_id)
	if client and client.server_capabilities.documentHighlightProvider then
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			buffer = event.buf,
			callback = vim.lsp.buf.document_highlight,
		})

		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
			buffer = event.buf,
			callback = vim.lsp.buf.clear_references,
		})
	end
end

return export
