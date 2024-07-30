-- Select and input UI.
return {
	{
		"stevearc/dressing.nvim",
		lazy = true,
		opts = {
			input = {
				backend = "telescope",
				win_options = {
					winhighlight = "FloatBorder:LspFloatWinBorder",
					winblend = 5,
				},
			},
			select = {
				trim_prompt = false,
				get_config = function(opts)
					if opts.kind == "codeaction" then
						return {
							backend = "telescope",
							builtin = {
								relative = "cursor",
								max_height = 0.33,
								min_height = 5,
								max_width = 0.40,
								mappings = { ["q"] = "Close" },
								win_options = {
									winhighlight = "FloatBorder:LspFloatWinBorder,DressingSelectIdx:LspInfoTitle,MatchParen:Ignore",
									winblend = 5,
								},
							},
						}
					end

					local winopts = { height = 0.6, width = 0.5 }

					-- Smaller menu for snippet choices.
					if opts.kind == "luasnip" then
						opts.prompt = "Snippet choice: "
						winopts = { height = 0.35, width = 0.3 }
					end

					-- Fallback to telescope
					return {
						backend = "telescope",
						telescope = { winopts = winopts },
					}
				end,
			},
		},
		init = function()
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.select = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.select(...)
			end
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.input = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.input(...)
			end
		end,
	},
}
