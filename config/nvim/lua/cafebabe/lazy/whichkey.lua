return {
    "folke/which-key.nvim",
    event = "VimEnter", -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
        vim.o.timeout = true
        vim.o.timeoutlen = 500
        require("which-key").setup()
    end
}
