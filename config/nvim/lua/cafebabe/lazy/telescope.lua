local function SetupTelescope()
	local telescope = require("telescope")
	local builtin = require("telescope.builtin")

	local extensions = { "themes", "terms", "fzf", "file_browser", "ui-select" }

	pcall(function()
		for _, ext in ipairs(extensions) do
			telescope.load_extension(ext)
		end
	end)

	vim.keymap.set("n", "<leader>ss", builtin.git_files, { desc = "[S]earch [S]GitFiles" })
	vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
	vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
	vim.keymap.set("n", "<leader>st", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
	vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
	vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
	vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
	vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
	vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
	vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })

	vim.keymap.set("n", "<leader>sb", function()
		require("telescope").extensions.file_browser.file_browser()
	end, { desc = "[S]earch [F]iles" })
	--
	vim.keymap.set("n", "<leader>sp", function()
		require("telescope").extensions.projects.projects({})
	end, { desc = "[S]earch [P]rojects" })
	--
	vim.keymap.set("n", "<leader>/", function()
		builtin.current_buffer_fuzzy_find()
	end, { desc = "[/] Fuzzily search in current buffer" })

	vim.keymap.set("n", "<leader>sn", function()
		builtin.find_files({ cwd = vim.fn.stdpath("config") })
	end, { desc = "[S]earch [N]eovim files" })

	vim.keymap.set("n", "<leader>sG", function()
		builtin.grep_string({ search = vim.fn.input("Grep > ") })
	end, { desc = "[S]earch by [G]rep in CWD" })

	vim.keymap.set("n", "<leader>cp", builtin.colorscheme, { desc = "[C]olorscheme [P]ick" })

	-- git commands
	vim.keymap.set("n", "<leader>gS", builtin.git_status, { desc = "[G]it [S]tatus Telescope" })
	vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "[G]it B[r]anch" })
	vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "[G]it [C]omits" })
end

return {
	"nvim-telescope/telescope-file-browser.nvim",
	dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	config = function()
		SetupTelescope()
		require("telescope").setup({
			file_ignore_patterns = { "node_modules", "build", "venv" },
			pickers = {
				pickers = {
					colorscheme = {
						enable_preview = true,
					},
				},
				find_files = {
					find_command = { "fdfind", "--strip-cwd-prefix", "--type", "f" },
					mappings = {
						n = {
							["cd"] = function(prompt_bufnr)
								local selection = require("telescope.actions.state").get_selected_entry()
								local dir = vim.fn.fnamemodify(selection.path, ":p:h")
								print(dir)
								require("telescope.actions").close(prompt_bufnr)
								-- Depending on what you want put `cd`, `lcd`, `tcd`
								vim.cmd(string.format("silent lcd %s", dir))
							end,
						},
					},
				},
			},
			vimgrep_arguments = {
				"rg",
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
				"--smart-case",
				"--trim",
			},
			extensions = {
				["file_browser"] = {
					hijack_netrw = true,
				},
				["fzf"] = {
					fuzzy = true, -- false will only do exact matching
					override_generic_sorter = true, -- override the generic sorter
					override_file_sorter = true, -- override the file sorter
					case_mode = "smart_case", -- or "ignore_case" or "respect_case"
				},
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
			},
		})
	end,
}
