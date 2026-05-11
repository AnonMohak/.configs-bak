return {

  {
    "nvim-lualine/lualine.nvim",

    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },

    config = function()
      require("lualine").setup({
        options = {
          theme = "tokyonight",
          globalstatus = true,
        },
      })
    end,
  },

  {
    "folke/which-key.nvim",

    event = "VeryLazy",

    config = function()
      require("which-key").setup()
    end,
  },

  {
    "numToStr/Comment.nvim",

    config = function()
      require("Comment").setup()
    end,
  },

  {
    "windwp/nvim-autopairs",

    event = "InsertEnter",

    config = function()
      require("nvim-autopairs").setup({})
    end,
  },
}
