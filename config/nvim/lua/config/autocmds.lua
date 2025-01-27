-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--
vim.api.nvim_create_autocmd("FileType", {
  pattern = "wiki",
  callback = function()
    vim.api.nvim_buf_set_keymap(0, "n", "<A-q>", "gww", { noremap = true })
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, { pattern = { "md", "vimwiki" }, command = "TSBufDisable highlight" })
