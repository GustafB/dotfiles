local window_mgmt = {
    name = "[W]indow Management",
    _ = "which_key_ignore",
    h = { "<cmd>vsplit<CR>", "split left" },
    j = { "<cmd>split<bar>wincmd j<CR>", "split down" },
    k = { "<cmd>split<CR>", "split up" },
    l = { "<cmd>vsplit<bar>wincmd l<CR>", "split right" },
    p = { "<cmd>lua require('nvim-window').pick()<CR>", "pick window" },
    r = { "<cmd>WinResizerStartResize<CR>", "resize mode" },
    e = { "<cmd>wincmd =<CR>", "equalize size" },
    -- m = { "<cmd>WinShift<CR>", "toggle window move mode" },
    -- s = { "<cmd>WinShift swap<CR>", "toggle window swap mode" },
    t = { "<cmd>wincmd T<CR>", "breakout into new tab" },
    q = { "<cmd>close<CR>", "close window" },
    o = { "<cmd>only<CR>", "only window" },
}

return {
    "folke/which-key.nvim",
    event = "VimEnter",
    config = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 500
        require("which-key").setup()

        require("which-key").register({
            ["<leader>l"] = { name = "[L]SP", _ = "which_key_ignore" },
            ["<leader>f"] = { name = "[F]ile Management", _ = "which_key_ignore" },
            ["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
            ["<leader>g"] = { name = "[G]it Actions", _ = "which_key_ignore" },
            ["<leader>w"] = window_mgmt
        })
    end
}
