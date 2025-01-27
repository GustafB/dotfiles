return {
  "nvim-treesitter/nvim-treesitter",
  config = function()
    vim.treesitter.language.register("markdown", { "vimwiki" })
  end,
  opts = function(_, opts)
    opts.ignore_install = { "vimwiki" }
  end,
}
