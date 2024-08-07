vim.g.have_nerd_font = true
--  Set cursor to fat cursor
vim.opt.guicursor = "n-v-i-c:block-Cursor"
-- [[ Setting options ]]
-- See `:help vim.opt`
vim.opt.tabstop = 4
-- Set the number of spaces to use for each step of (auto)indent.
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
-- Convert tabs to spaces.
vim.opt.expandtab = true
-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, for help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true
-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"
-- Don't show the mode, since it's already in status line
vim.opt.showmode = false
-- Enable break indent
vim.opt.breakindent = true
-- Save undo history
vim.opt.undofile = true
-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"
-- Decrease update time
vim.opt.updatetime = 50
-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300
-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true
-- Sets how neovim will display certain whitespace in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { space = "⋅", tab = "» ", trail = "⋅", nbsp = "␣" }
-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"
-- Show which line your cursor is on
vim.opt.cursorline = true
-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 8

-- undostuff
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.wildmode = "list:longest,list:full" -- for : stuff
vim.opt.wildignore:append({ "node_modules", "*.pyc" })
vim.opt.wildignore:append({ ".aux", ".out", ".toc" }) -- LaTeX
vim.opt.wildignore:append({
	".o",
	".obj",
	".dll",
	".exe",
	".so",
	".a",
	".lib",
	".pyc",
	".pyo",
	".pyd",
	".swp",
	".swo",
	".class",
	".DS_Store",
	".git",
	".hg",
	".orig",
})
vim.opt.suffixesadd:append({ ".java", ".rs" }) -- search for suffexes using gf

-- turn off smartindent
-- vim.opt.smartindent = false

-- disable swap file
vim.opt.swapfile = false
