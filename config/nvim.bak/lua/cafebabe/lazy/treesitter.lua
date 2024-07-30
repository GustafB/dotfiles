return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"vimdoc",
					"javascript",
					"typescript",
					"cpp",
					"c",
					"lua",
					"rust",
					"jsdoc",
					"bash",
					"go",
					"org",
				},

				sync_install = false,

				auto_install = true,

				-- indent = {
				-- 	enable = true,
				-- },

				highlight = {
					enable = true,
					additional_vim_regex_highlighting = { "go" }, -- Enable for Golang
				},
			})

			local treesitter_parser_config = require("nvim-treesitter.parsers").get_parser_configs()
			treesitter_parser_config.templ = {
				install_info = {
					url = "https://github.com/vrischmann/tree-sitter-templ.git",
					files = { "src/parser.c", "src/scanner.c" },
					branch = "master",
				},
			}

			vim.treesitter.language.register("templ", "templ")
			-- vim.api.nvim_set_hl(0, "@content.injection", { bg = "#1e1e1e", fg = "#ffffff" })
			-- vim.api.nvim_set
			-- vim.cmd([[highlight link @injection.content.sql InjectedSQL]])
		end,
	},
	{
		"RRethy/nvim-treesitter-textsubjects",
		config = function()
			require("nvim-treesitter.configs").setup({
				textsubjects = {
					enable = true,
					keymaps = {
						["i;"] = {
							"textsubjects-container-inner",
							desc = "Select inside containers (classes, functions, etc.)",
						},
					},
				},
			})
		end,
	},
}
