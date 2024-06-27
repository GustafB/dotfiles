return {
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				bash = { "shfmt" },
				sh = { "shfmt" },
				fish = { "fish_indent" },
				go = { "goimports", "gofumpt", "goimports-reviser" },
				javascript = { { "prettierd", "prettier" } },
				typescript = { { "prettierd", "prettier" } },
				javascriptreact = { { "prettierd", "prettier" } },
				typescriptreact = { { "prettierd", "prettier" } },
				css = { { "prettierd", "prettier" } },
				scss = { { "prettierd", "prettier" } },
				html = { { "prettierd", "prettier" } },
				json = { { "prettierd", "prettier" } },
				jsonc = { { "prettierd", "prettier" } },
				yaml = { { "prettierd", "prettier" } },
				svelte = { { "prettierd", "prettier" } },
				lua = { "stylua" },
				python = function(bufnr)
					if require("conform").get_formatter_info("ruff_format", bufnr).available then
						return { "ruff_format" }
					else
						return { "isort", "black" }
					end
				end,
				cpp = { "clang-format" },
				c = { "clang-format" },
				-- Use the "*" filetype to run formatters on all filetypes.
				["*"] = { "codespell" },
				["_"] = { "trim_whitespace" },
			},
			format_on_save = {
				lsp_fallback = true,
				timeout_ms = 500,
			},
		},
	},
	{
		"nmac427/guess-indent.nvim",
		config = function()
			require("guess-indent").setup({})
		end,
	},
}
