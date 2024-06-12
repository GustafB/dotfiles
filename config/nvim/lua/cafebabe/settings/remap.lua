vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
-- vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
-- vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
--
-- workspace diagnostics
vim.keymap.set("n", "<leader>xd", function()
	require("trouble").toggle("workspace_diagnostics")
end)

-- insert empty lines
-- vim.api.nvim_set_keymap("n", "<C-j>", [[:silent +g/\m^\s*$/d<CR>]], { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<C-k>", [[:silent -g/\m^\s*$/d<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-j>", [[:set paste<CR>m`o<Esc>``:set nopaste<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-k>", [[:set paste<CR>m`O<Esc>``:set nopaste<CR>]], { noremap = true, silent = true })

-- move lines around in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- disable Q
vim.keymap.set("n", "Q", "<nop>")

-- cancel on C-g
vim.keymap.set("n", "C-g", "<Esc>")

-- format buffer

-- use system clipboard
vim.keymap.set("n", "<leader>y", '"+y', { desc = "yank to system clipboard" })
vim.keymap.set("n", "<leader>p", '"+p', { desc = "paste from system clipboard" })
-- vim.keymap.set("n", "<leader>d", '"+d', { desc = "delete to system clipboard" })
--
