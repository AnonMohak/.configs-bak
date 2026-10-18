-- Leader key already set in init.lua

vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic" })
vim.keymap.set("n", "<leader>q", ":q<CR>")
vim.keymap.set("n", "<leader>x", ":x<CR>")
vim.keymap.set("n", "<leader>vi", function ()
  Snacks.dashboard()
end, {desc = "Open Dashboard"})
vim.keymap.set("n", "<leader>cc", "<cmd>ClaudeCode<cr>", {
  desc="Open Claude Code"
})
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-l>", "<C-w>l")
