return {

  {
    "stevearc/oil.nvim",

    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },

    config = function()
      require("oil").setup()

      vim.keymap.set("n", "-", "<CMD>Oil<CR>")
    end,
  },

  {
    "nvim-neo-tree/neo-tree.nvim",

    branch = "v3.x",

    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },

    config = function()
      require("neo-tree").setup({})
    end,
  },

  {
    "folke/flash.nvim",

    event = "VeryLazy",

    opts = {},

    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },

      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
    },
  },

  {
  "folke/persistence.nvim",

  event = "BufReadPre",

  opts = {},
  },
}
