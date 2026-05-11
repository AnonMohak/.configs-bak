return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",

    config = function()
      require("nvim-treesitter.install").compilers = { "gcc" }

      require("nvim-treesitter").setup({
        ensure_installed = {
          "lua",
          "vim",
          "vimdoc",
          "query",
          "javascript",
          "typescript",
          "tsx",
          "python",
          "html",
          "css",
          "c",
          "cpp",
          "json",
          "yaml",
          "bash",
          "markdown",
          "markdown_inline",
        },

        highlight = {
          enable = true,
        },
      })
    end,
  },
}
