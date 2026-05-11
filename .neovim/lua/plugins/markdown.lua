return {
  {
    "MeanderingProgrammer/render-markdown.nvim",

    ft = { "markdown" },

    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },

    config = function()
      require("render-markdown").setup({
      headings = {
        enabled = true,
      },
      bullet = {
        enabled = true,
      },
      checkbox = {
        enabled = true,
      },
      })
    end,
  },
}
