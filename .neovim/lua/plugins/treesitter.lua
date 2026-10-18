-- return {
--   {
--     "nvim-treesitter/nvim-treesitter",
--     build = ":TSUpdate",
--
--     config = function()
--       require("nvim-treesitter.install").compilers = { "gcc" }
--
--       require("nvim-treesitter").setup({
--         ensure_installed = {
--           "lua",
--           "vim",
--           "vimdoc",
--           "query",
--           "javascript",
--           "typescript",
--           "tsx",
--           "python",
--           "html",
--           "css",
--           "c",
--           "cpp",
--           "json",
--           "yaml",
--           "bash",
--           "markdown",
--           "markdown_inline",
--         },
--
--         highlight = {
--           enable = true,
--         },
--       })
--     end,
--   },
-- }
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
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "lua",
          "vim",
          "javascript",
          "typescript",
          "typescriptreact",
          "javascriptreact",
          "python",
          "html",
          "css",
          "c",
          "cpp",
          "json",
          "yaml",
          "bash",
          "markdown",
        },
        callback = function()
          vim.treesitter.start()
        end,
      })
    end,
  },
}
