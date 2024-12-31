return {
  "folke/edgy.nvim",
  enabled = false,
  opts = {
    left = {
      --{ title = "Neotest Summary", ft = "neotest-summary" },
      { title = "Files", ft = "neo-tree", size = { width = 0.1 } },
    },
    right = {
      { title = "Types", ft = "aerial", size = { width = 1 } },
    },
  },
}
