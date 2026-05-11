return {

  {
    "NeogitOrg/neogit",

    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },

    config = function()
      require("neogit").setup({})
    end,
  },

  {
    "lewis6991/gitsigns.nvim",

    config = function()
      require("gitsigns").setup()
    end,
  },

  {
    "folke/todo-comments.nvim",

    dependencies = {
      "nvim-lua/plenary.nvim",
    },

    config = function()
      require("todo-comments").setup({})
    end,
  },
}
