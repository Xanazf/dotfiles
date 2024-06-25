local function import_colorscheme(colorscheme_name)
  local config_path = "plugins.colorscheme." .. colorscheme_name
  local ok, config = pcall(require, config_path)
  if ok then
    return config
  else
    vim.notify("Failed to load colorscheme configuration for " .. colorscheme_name, vim.log.levels.ERROR)
  end
end

return {
  import_colorscheme("eldritch"),
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "eldritch",
      defaults = {
        autocmds = true,
        keymaps = true,
      },
    },
  },
  { "HiPhish/rainbow-delimiters.nvim" },
  { "nvim-treesitter/nvim-treesitter-context" },
  {
    "tris203/precognition.nvim",
    event = "VeryLazy",
    opts = {
      startVisible = true,
      showBlankVirtLine = true,
      highlightColor = { link = "Comment" },
      hints = {
        Caret = { text = "^", prio = 2 },
        Dollar = { text = "$", prio = 1 },
        MatchingPair = { text = "%", prio = 5 },
        Zero = { text = "0", prio = 1 },
        w = { text = "w", prio = 10 },
        b = { text = "b", prio = 9 },
        e = { text = "e", prio = 8 },
        W = { text = "W", prio = 7 },
        B = { text = "B", prio = 6 },
        E = { text = "E", prio = 5 },
      },
      gutterHints = {
        G = { text = "G", prio = 10 },
        gg = { text = "gg", prio = 9 },
        PrevParagraph = { text = "{", prio = 8 },
        NextParagraph = { text = "}", prio = 8 },
      },
    },
  },
  {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    opts = {},
  },
  {
    "windwp/nvim-ts-autotag",
    config = function(_, opts)
      require("nvim-ts-autotag").setup(opts)
    end,
  },
  {
    "j-hui/fidget.nvim",
    opts = {},
    event = "VeryLazy",
  },
  {
    "folke/trouble.nvim",
    enabled = true,
  },
}
