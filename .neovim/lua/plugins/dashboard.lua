return {
  {
    "folke/snacks.nvim",

    priority = 1000,
    lazy = false,

    opts = {
      dashboard = {
        enabled = true,

        sections = {
          {
            pane = 1,

            {
              text = require("art.zoro").zoro,

              opts = {
                hl = "Error",
                align = "center",
              },
            },
          },

          {
            pane = 2,
            section = "keys",
            gap = 1,
            padding = 1,
          },
        },

        preset = {
          keys = {

            -- FILES
            {
              icon = " ",
              key = "n",
              desc = "New File",
              action = ":ene | startinsert",
            },

            {
              icon = " ",
              key = "f",
              desc = "Find File",
              action = ":Telescope find_files",
            },

            {
              icon = " ",
              key = "r",
              desc = "Recent Files",
              action = ":Telescope oldfiles",
            },

            {
              icon = " ",
              key = "e",
              desc = "File Explorer",
              action = ":Neotree toggle",
            },

            {
              icon = " ",
              key = "k",
              desc = "Keymaps",
              action = ":Telescope keymaps",
            },

            {
              icon = " ",
              key = "d",
              desc = "Todos",
              action = ":TodoTelescope",
            },

            {
              icon = " ",
              key = "p",
              desc = "Find Files (Home)",
              action = ":Telescope find_files cwd=~",
            },

            -- SEARCH
            {
              icon = " ",
              key = "g",
              desc = "Grep Text",
              action = ":Telescope live_grep",
            },

            {
              icon = "󰱼 ",
              key = "w",
              desc = "Word Finder",
              action = ":Telescope grep_string",
            },

            -- DEV
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = ":e $MYVIMRC",
            },

            {
              icon = "󰒲 ",
              key = "l",
              desc = "Lazy",
              action = ":Lazy",
            },

            {
              icon = " ",
              key = "u",
              desc = "Update Plugins",
              action = ":Lazy sync",
            },

            {
              icon = " ",
              key = "s",
              desc = "Git Status",
              action = ":Neogit",
            },

            -- UTIL
            {
              icon = " ",
              key = "t",
              desc = "WezTerm",
              action = ":!wezterm",
            },
            -- SESSION
            { icon = " ",
              key = "S", 
              desc = "Restore Session", 
              action = ":lua require('persistence').load()" 
            },

            {
              icon = "󱞁 ",
              key = "x",
              desc = "Scratch File",
              action = ":enew",
            },

            -- EXIT
            {
              icon = " ",
              key = "q",
              desc = "Quit",
              action = ":qa",
            },
          },
        },
      },
    },

    config = function(_, opts)
      require("snacks").setup(opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = "SnacksDashboardOpened",

        callback = function()
          vim.opt_local.laststatus = 0
          vim.opt_local.ruler = false
          vim.opt_local.showmode = false
          vim.opt_local.showcmd = false

          vim.api.nvim_create_autocmd("BufWipeout", {
            buffer = 0,

            callback = function()
              vim.opt.laststatus = 3
              vim.opt.ruler = true
              vim.opt.showmode = true
              vim.opt.showcmd = true
            end,
          })
        end,
      })
    end,
  },
}
