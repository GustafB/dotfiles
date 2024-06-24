local methods = vim.lsp.protocol.Methods
local cafe_namespace = vim.api.nvim_create_namespace("cafebabe/lsp_float")

---LSP handler that adds extra inline highlights, keymaps, and window options.
---Code inspired from `https://github.com/MariaSolOs/dotfiles`.
---@param handler fun(err: any, result: any, ctx: any, config: any): integer, integer
---@return function
local function enhanced_float_handler(handler)
	return function(err, result, ctx, config)
		local buf, win = handler(
			err,
			result,
			ctx,
			vim.tbl_deep_extend("force", config or {}, {
				border = "rounded",
				max_height = math.floor(vim.o.lines * 0.5),
				max_width = math.floor(vim.o.columns * 0.4),
			})
		)

		if not buf or not win then
			return
		end

		-- Conceal everything.
		vim.wo[win].concealcursor = "n"

		-- Extra highlights.
		for l, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
			for pattern, hl_group in pairs({
				["|%S-|"] = "@text.reference",
				["@%S+"] = "@parameter",
				["^%s*(Parameters:)"] = "@text.title",
				["^%s*(Return:)"] = "@text.title",
				["^%s*(See also:)"] = "@text.title",
				["{%S-}"] = "@parameter",
			}) do
				local from = 1 ---@type integer?
				while from do
					local to
					from, to = line:find(pattern, from)
					if from then
						vim.api.nvim_buf_set_extmark(buf, cafe_namespace, l - 1, from - 1, {
							end_col = to,
							hl_group = hl_group,
						})
					end
					from = to and to + 1 or nil
				end
			end
		end

		-- Add keymaps for opening links.
		if not vim.b[buf].markdown_keys then
			vim.keymap.set("n", "K", function()
				-- Vim help links.
				local url = (vim.fn.expand("<cWORD>") --[[@as string]]):match("|(%S-)|")
				if url then
					return vim.cmd.help(url)
				end

				-- Markdown links.
				local col = vim.api.nvim_win_get_cursor(0)[2] + 1
				local from, to
				from, to, url = vim.api.nvim_get_current_line():find("%[.-%]%((%S-)%)")
				if from and col >= from and col <= to then
					vim.system({ "open", url }, nil, function(res)
						if res.code ~= 0 then
							vim.notify("Failed to open URL" .. url, vim.log.levels.ERROR)
						end
					end)
				end
			end, { buffer = buf, silent = true })
			vim.b[buf].markdown_keys = true
		end
	end
end

local function cafebabe_lsp_map_kbds(bufnr)
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
	map("<leader>ls", require("telescope.builtin").lsp_document_symbols, "Document [S]symbols")

	-- Fuzzy find all the symbols in your current workspace
	--  Similar to document symbols, except searches over your whole project.
	map("<leader>lw", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace Symbols")

	-- Rename the variable under your cursor
	--  Most Language Servers support renaming across files, etc.
	map("<leader>ln", vim.lsp.buf.rename, "Re[n]ame")

	-- Execute a code action, usually your cursor needs to be on top of an error
	-- or a suggestion from your LSP for this to activate.
	map("<leader>la", vim.lsp.buf.code_action, "Code [A]ction")

	-- Opens a popup that displays documentation about the word under your cursor
	--  See `:help K` for why this keymap
	map("<leader>lk", vim.lsp.buf.hover, "Hover Documentation")

	-- WARN: This is not Goto Definition, this is Goto Declaration.
	--  For example, in C this would take you to the header
	map("<leader>lD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

	map("<leader>lf", function()
		require("conform").format({ async = true, lsp_fallback = true })
	end, "[L]SP [F]ormat Buffer")
end

---Sets up LSP keymaps and autocommands for the given buffer.
local function cafebabe_lsp_on_attach(client, bufnr)
	cafebabe_lsp_map_kbds(bufnr)

	if client.supports_method(methods.textDocument_hover) then
		vim.lsp.handlers[methods.textDocument_hover] = enhanced_float_handler(vim.lsp.handlers.hover)
	end

	if client.supports_method(methods.textDocument_signatureHelp) then
		vim.lsp.handlers[methods.textDocument_signatureHelp] = enhanced_float_handler(vim.lsp.handlers.signature_help)
	end

	if client.supports_method(methods.textDocument_documentHighlight) then
		local under_cursor_highlights_group =
			vim.api.nvim_create_augroup("cafebabe/cursor_highlights", { clear = false })
		vim.api.nvim_create_autocmd({ "CursorHold", "InsertLeave", "BufEnter" }, {
			group = under_cursor_highlights_group,
			desc = "Highlight references under the cursor",
			buffer = bufnr,
			callback = vim.lsp.buf.document_highlight,
		})
		vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave" }, {
			group = under_cursor_highlights_group,
			desc = "Clear highlight references",
			buffer = bufnr,
			callback = vim.lsp.buf.clear_references,
		})
	end

	if client.name == "clangd" then
		vim.keymap.set(
			"n",
			"<leader><Tab>",
			":ClangdSwitchSourceHeader<CR>",
			{ desc = "Switch Source Header", noremap = true, silent = true, buffer = bufnr }
		)
	end

	require("lsp_signature").on_attach({
		handler_opts = {
			border = "rounded", -- double, rounded, single, shadow, none, or a table of borders
		},
	}, bufnr)
end

vim.api.nvim_create_autocmd("LspAttach", {
	desc = "Configure keymaps and other configuration",
	group = vim.api.nvim_create_augroup("cafebabe-lsp-auto", { clear = true }),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)

		if not client then
			return
		end

		cafebabe_lsp_on_attach(client, args.buf)
	end,
})

return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"j-hui/fidget.nvim",
	},

	config = function()
		local servers = {
			"lua_ls",
			"rust_analyzer",
			"tsserver",
			"clangd",
			"gopls",
			"pyright",
			"html",
			"gofumpt",
			"svelte",
			"cypher_ls",
		}
		local cmp = require("cmp")
		local cmp_lsp = require("cmp_nvim_lsp")
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			cmp_lsp.default_capabilities()
		)
		require("fidget").setup({})
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_isntalled = vim.tbl_keys(servers or {}),
			handlers = {
				function(server_name) -- default handler (optional)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
					})
				end,

				["lua_ls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.lua_ls.setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								diagnostics = {
									globals = { "vim", "it", "describe", "before_each", "after_each" },
								},
							},
						},
					})
				end,

				["clangd"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.clangd.setup({
						cmd = { "clangd", "--background-index", "--clang-tidy" },
						filetypes = { "c", "cpp", "objc", "objcpp", "hpp", "h" },
						capabilities = capabilities,
						single_file_support = true,
					})
				end,

				["gopls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.gopls.setup({
						capabilities = capabilities,
						cmd = { "gopls" },
						filetypes = { "go", "gomod", "gowork", "gotmpl" },
						settings = {
							gopls = {
								completeUnimported = true,
								usePlaceholders = true,
								analyses = {
									unusedparams = true,
									nilness = true,
									unusedwrite = true,
									useany = true,
								},
								gofumpt = true,
								staticcheck = true,
								hints = {
									assignVariableTypes = true,
									compositeLiteralFields = true,
									compositeLiteralTypes = true,
									constantValues = true,
									functionTypeParameters = true,
									parameterNames = true,
									rangeVariableTypes = true,
								},
							},
						},
					})
				end,
				["cypher_ls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.cypher_ls.setup({
						capabilities = capabilities,
					})
				end,
			},
		})

		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
				["<Tab>"] = cmp.mapping(function(fallback)
					local status_ok, luasnip = pcall(require, "luasnip")
					if status_ok and luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					local status_ok, luasnip = pcall(require, "luasnip")
					if status_ok and luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "buffer" },
			}, {
				{ name = "buffer" },
			}),
		})

		vim.diagnostic.config({
			-- update_in_insert = true,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		})
	end,
}
