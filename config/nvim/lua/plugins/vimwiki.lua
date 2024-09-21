return {
  "vimwiki/vimwiki",
  event = "BufEnter *.md",
  keys = { "<leader>ww", "<leader>wt" },
  init = function()
    vim.g.vimwiki_list = {
      {
        path = "~/docs/vimwiki/",
        syntax = "markdown",
        ext = "md",
      },
    }
    vim.g.vimwiki_ext2syntax = { [".md"] = "markdown", [".markdown"] = "markdown", [".mdown"] = "markdown" }
    vim.g.vimwiki_global_ext = 0
  end,
}
