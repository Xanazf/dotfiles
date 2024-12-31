return {
  "nvimdev/lspsaga.nvim",
  enabled = true,
  lazy = true,
  event = "LspAttach",
  config = function()
    require("lspsaga").setup({
      ui = {
        devicon = true,
        code_action = "",
      },
    })
  end,
  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- optional
    "nvim-tree/nvim-web-devicons", -- optional
  },
}
