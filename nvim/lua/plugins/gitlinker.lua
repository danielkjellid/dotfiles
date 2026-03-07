return {
  "linrongbin16/gitlinker.nvim",
  cmd = "GitLink",
  event = "VeryLazy",
  opts = {},
  keys = {
    { "<leader>gc", "<cmd>GitLink<cr>", mode = { "n", "v" }, desc = "Yank git link" },
    { "<leader>go", "<cmd>GitLink!<cr>", mode = { "n", "v" }, desc = "Open git link" },
  },
}