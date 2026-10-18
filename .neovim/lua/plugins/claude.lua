return {
  {
    "coder/claudecode.nvim",
    dependencies = {
      "folke/snacks.nvim",
    },
    config = true,
    cmd = {
      "ClaudeCode",
      "ClaudeCodeFocus",
      "ClaudeCodeSend",
      "ClaudeCodeAdd",
      "ClaudeCodeDiffAccept",
      "ClaudeCodeDiffDeny",
    }, 
    opts = {
      terminal = {
        split_side = "right",
        split_width_percentage = 0.5,
      },
    },
  },
}
