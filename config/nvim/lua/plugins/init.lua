-- install lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- Lazy load plugins
require("lazy").setup({
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
	-- golang specific tools
	{
		"ray-x/go.nvim",
		dependencies = { -- optional packages
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("go").setup()
		end,
		event = { "CmdlineEnter" },
		ft = { "go", "gomod" },
		build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
	},
	--
	-- project management
	{
		"ahmedkhalf/project.nvim",
		config = function()
			require("plugins.configs.project").setup()
		end,
	},
	--
	-- inline biscuits
	{
		"code-biscuits/nvim-biscuits",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("plugins.configs.biscuits").setup()
		end,
	},
	--
	-- Inline lsp context
	{
		"utilyre/barbecue.nvim",
		name = "barbecue",
		version = "*",
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons", -- optional dependency
		},
	},
	--
	-- List errors in quickfix window
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	--
	-- Virtual annotation at the end of line for closing brackets
	-- Render inline diagnostics for lsp
	{
		"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
		config = function()
			require("lsp_lines").setup()
		end,
	},
	--
	-- Highlight todo, notes, etc in comments
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},

	{ -- terminal toggle
		"akinsho/toggleterm.nvim",
		config = function()
			require("plugins.configs.toggleterm").setup()
		end,
	},

	{
		"xiyaowong/transparent.nvim",
		config = function()
			require("transparent").setup({
				extra_groups = {
					"NvimTreeNormal",
					"NvimTreeNormalNC",
					-- Add other groups
				},
			})
			vim.api.nvim_set_keymap("n", "<leader>tt", ":TransparentToggle<CR>", { noremap = true, silent = true })
		end,
	},
	{
		"goolord/alpha-nvim",
		config = function()
			require("plugins.configs.alpha").setup()
		end,
	},

	{ "numToStr/Comment.nvim", opts = {} }, -- "gc" to comment visual regions/lines

	{
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			scope = { enabled = false }, -- Disabling the current scope highlighting
		},
	},

	-- {
	-- 	"github/copilot.vim",
	-- 	config = function()
	-- 		vim.keymap.set("i", "<M-j>", 'copilot#Accept("<CR>")', { expr = true, replace_keycodes = false })
	-- 		vim.keymap.del("i", "<Tab>")
	-- 		vim.g.copilot_no_tab_map = true
	-- 		vim.g.copilot_assume_mapped = true
	-- 		vim.keymap.set("i", "<M-w>", "<Plug>(copilot-accept-word)")
	-- 		vim.keymap.set("i", "<M-n>", "<Plug>(copilot-next)")
	-- 		vim.keymap.set("i", "<M-p>", "<Plug>(copilot-previous)")
	-- 	end,
	-- },
	--
	{
		"akinsho/bufferline.nvim",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			require("bufferline").setup({
				vim.keymap.set("n", "<leader>bn", "<Cmd>BufferLineCycleNext<CR>", { noremap = true, silent = true }),
				vim.keymap.set("n", "<leader>bb", "<Cmd>BufferLineCyclePrev<CR>", { noremap = true, silent = true }),
			})
		end,
	},

	{
		"kyazdani42/nvim-tree.lua",
		requires = "kyazdani42/nvim-web-devicons", -- optional, for file icons
		config = function()
			require("nvim-tree").setup({})
			-- Keymap for <leader>e to toggle the nvim-tree
			vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
		end,
	},

	-- Here is a more advanced example where we pass configuration
	-- options to `gitsigns.nvim`. This is equivalent to the following lua:
	--    require('gitsigns').setup({ ... })
	--
	-- See `:help gitsigns` to understand what the configuration keys do
	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
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
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},

	{ -- Useful plugin to show you pending keybinds.
		"folke/which-key.nvim",
		event = "VimEnter", -- Sets the loading event to 'VimEnter'
		config = function() -- This is the function that runs, AFTER loading
			vim.o.timeout = true
			vim.o.timeoutlen = 500
			require("which-key").setup()
			-- Document existing key chains
			require("which-key").register({
				["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
				["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
				["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
				["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
				["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
				["<leader>o"] = {
					name = "Wind[o]w Management",
					_ = "which_key_ignore",
					h = { "<cmd>vsplit<CR>", "split left" },
					j = { "<cmd>split<bar>wincmd j<CR>", "split down" },
					k = { "<cmd>split<CR>", "split up" },
					l = { "<cmd>vsplit<bar>wincmd l<CR>", "split right" },
					p = { "<cmd>lua require('nvim-window').pick()<CR>", "pick window" },
					r = { "<cmd>WinResizerStartResize<CR>", "resize mode" },
					e = { "<cmd>wincmd =<CR>", "equalize size" },
					m = { "<cmd>WinShift<CR>", "toggle window move mode" },
					s = { "<cmd>WinShift swap<CR>", "toggle window swap mode" },
					z = { "<cmd>ZenMode<CR>", "toggle zen mode" },
					t = { "<cmd>wincmd T<CR>", "breakout into new tab" },
				},
			})
		end,
	},

	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	},

	require("plugins.utils"),
	require("plugins.colorschemes"),
}, {
	ui = {
		-- If you have a Nerd Font, set icons to an empty table which will use the
		-- default lazy.nvim defined Nerd Font icons otherwise define a unicode icons table
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})
