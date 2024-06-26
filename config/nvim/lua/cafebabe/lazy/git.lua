return {
	--[[ 	{
		"tpope/vim-fugitive",
		config = function()
			local opts = function(desc, bufnr, remap)
				local opts = { buffer = bufnr, remap = remap, desc = desc }
				return opts
			end

			vim.keymap.set("n", "<leader>gs", vim.cmd.Git, opts("[G]it [S]tatus"))

			local cafebabe_fugitive = vim.api.nvim_create_augroup("cafebabe_fugitive", {})
			local autocmd = vim.api.nvim_create_autocmd
			autocmd("BufWinEnter", {
				group = cafebabe_fugitive,
				pattern = "*",
				callback = function()
					if vim.bo.ft ~= "fugitive" then
						return
					end

					local bufnr = vim.api.nvim_get_current_buf()
					vim.keymap.set("n", "gp", function()
						vim.cmd.Git("push")
					end, opts("[G]it [P]ush", bufnr, false))

					vim.keymap.set("n", "gF", function()
						vim.cmd.Git({ "pull", "--rebase" })
					end, opts("[G]it Pull Rebase", bufnr, false))

					vim.keymap.set("n", "gt", ":Git push --set-upstream ", opts("[G]it Push Origin"))
					vim.keymap.set("n", "gh", "<cmd>diffget //2<CR>", opts("Select left buffer", bufnr, false))
					vim.keymap.set("n", "gl", "<cmd>diffget //3<CR>", opts("Select right buffer", bufnr, false))
				end,
			})
		end,
	}, ]]
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"nvim-telescope/telescope.nvim",
		},
		config = true,
		lazy = false,
		keys = {
			{ "<leader>gs", "<cmd>Neogit<cr>", "[G]it [S]tatus" },
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		config = true,
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},
	{
		"FabijanZulj/blame.nvim",
		config = function()
			require("blame").setup()
			vim.keymap.set(
				"n",
				"<leader>gl",
				":BlameToggle virtual<CR>",
				{ desc = "Toggle [G]it B[l]ame Pane", remap = false }
			)
		end,
	},
	{
		"linrongbin16/gitlinker.nvim",
		cmd = "GitLink",
		opts = {},
		keys = {
			{ "<leader>gy", "<cmd>GitLink<cr>", mode = { "n", "v" }, desc = "Yank git link" },
			{ "<leader>gY", "<cmd>GitLink!<cr>", mode = { "n", "v" }, desc = "Open git link" },
		},
	},
}
