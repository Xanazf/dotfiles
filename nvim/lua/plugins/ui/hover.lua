return {
  {
    "lewis6991/hover.nvim",
    event = "VeryLazy",
    config = function()
      local hover = require("hover")
      local hover_util = require("hover.util")

      -- Use Snacks.win to render the hover content
      -- This provides a much more robust and beautiful UI than the default hover handler
      hover_util.open_floating_preview = function(contents, _, syntax, _)
        return Snacks.win({
          text = contents,
          ft = syntax == "markdown" and "markdown" or "plaintext",
          width = 0.6,
          height = 0.4,
          border = "rounded",
          backdrop = 60,
          wo = {
            winhighlight = "Normal:NormalFloat,FloatBorder:DiagnosticInfo",
            conceallevel = 2,
            concealcursor = "n",
          },
        })
      end

      hover.setup({
        init = function()
          require("hover.providers.lsp")
          require("hover.providers.diagnostic")
          require("hover.providers.dap")
          require("hover.providers.man")
        end,
        preview_opts = {
          border = "rounded",
        },
        preview_extract_button = "focus",
        title = true,
      })

      -- Setup keymaps
      vim.keymap.set("n", "K", require("hover").hover, { desc = "hover.nvim" })
      vim.keymap.set("n", "gK", require("hover").hover_select, { desc = "hover.nvim (select)" })
      vim.keymap.set("n", "<C-p>", function()
        require("hover").hover_switch("previous")
      end, { desc = "hover.nvim (previous source)" })
      vim.keymap.set("n", "<C-n>", function()
        require("hover").hover_switch("next")
      end, { desc = "hover.nvim (next source)" })

      -- Mouse support (optional, uncomment if desired)
      -- vim.keymap.set('n', '<MouseMove>', require('hover').hover_mouse, { desc = 'hover.nvim (mouse)' })
      -- vim.o.mousemoveevent = true
    end,
  },
}
