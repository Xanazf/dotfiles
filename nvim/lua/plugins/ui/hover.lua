return {
  {
    "lewis6991/hover.nvim",
    event = "VeryLazy",
    config = function()
      local hover = require("hover")
      local hover_util = require("hover.util")

      -- Use Snacks.win to render the hover content
      -- This provides a much more robust and beautiful UI than the default hover handler
      hover_util.open_floating_preview = function(contents, bufnr, syntax, opts)
        local cbuf = vim.api.nvim_get_current_buf()

        -- Close existing hover for this buffer if it exists
        local existing = vim.b[cbuf].hover_preview
        if existing and vim.api.nvim_win_is_valid(existing) then
          vim.api.nvim_win_close(existing, true)
        end

        local lines = type(contents) == "table" and contents or {}
        if type(contents) == "string" then
          lines = vim.split(contents, "\n")
        elseif bufnr and #lines == 0 then
          lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        end

        local sw = vim.api.nvim_win_get_width(0)
        local sh = vim.api.nvim_win_get_height(0)

        -- Pre-calculate width to ensure it's a static number during initialization
        local max_content_w = 0
        for _, line in ipairs(lines) do
          max_content_w = math.max(max_content_w, vim.fn.strdisplaywidth(line))
        end

        -- Cap at 80 columns or 70% of split width, whichever is smaller
        local target_w = math.min(80, math.floor(sw * 0.7))
        target_w = math.min(max_content_w + 2, target_w)
        target_w = math.max(target_w, 30) -- maintain a reasonable minimum

        local cwin = vim.api.nvim_get_current_win()
        local win = Snacks.win({
          buf = bufnr,
          text = contents,
          ft = syntax == "markdown" and "markdown" or "plaintext",
          width = target_w,
          height = function(self)
            local h = 0
            for _, line in ipairs(self:lines()) do
              local lw = vim.fn.strdisplaywidth(line)
              h = h + math.max(1, math.ceil(lw / target_w))
            end
            -- Add 1 for the title bar (winbar / tabs)
            return math.min(h + 1, math.floor(sh * 0.8))
          end,
          relative = "cursor",
          position = "float",
          row = 1,
          col = 0,
          border = "rounded",
          backdrop = 60,
          -- Disable minimal to allow winbar (tabs) to show
          minimal = false,
          wo = {
            winhighlight = "Normal:NormalFloat,FloatBorder:DiagnosticInfo",
            conceallevel = 2,
            concealcursor = "n",
            wrap = true,
            breakindent = true,
            number = false,
            relativenumber = false,
            cursorline = false,
            signcolumn = "no",
            foldcolumn = "0",
          },
          on_close = function()
            if vim.api.nvim_buf_is_valid(cbuf) then
              vim.b[cbuf].hover_preview = nil
            end
          end,
        })

        -- Set variables hover.nvim expects for tracking and cycling
        vim.b[cbuf].hover_preview = win.win
        vim.w[win.win].hover_preview = win.win
        vim.w[win.win].hover = cbuf

        -- Explicitly set keys on the floating buffer to override defaults
        local map_opts = { buffer = win.buf, noremap = true, silent = true, nowait = true }
        vim.keymap.set("n", "K", function()
          vim.api.nvim_set_current_win(cwin)
          require("hover").open()
        end, map_opts)
        vim.keymap.set("n", "<C-n>", function()
          vim.api.nvim_set_current_win(cwin)
          require("hover").switch("next")
        end, map_opts)
        vim.keymap.set("n", "<C-p>", function()
          vim.api.nvim_set_current_win(cwin)
          require("hover").switch("previous")
        end, map_opts)

        -- Create autocmds to close the window on movement

        -- Create autocmds to close the window on movement
        local group = vim.api.nvim_create_augroup("hover_preview_" .. win.win, { clear = true })

        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "InsertEnter" }, {
          group = group,
          buffer = cbuf,
          callback = function()
            if win:valid() then
              win:close()
            end
            pcall(vim.api.nvim_del_augroup_by_id, group)
          end,
        })

        -- Close when focusing any other window EXCEPT the hover window itself
        vim.api.nvim_create_autocmd("BufEnter", {
          group = group,
          callback = function()
            local cur_buf = vim.api.nvim_get_current_buf()
            if cur_buf ~= cbuf and cur_buf ~= win.buf then
              if win:valid() then
                win:close()
              end
              pcall(vim.api.nvim_del_augroup_by_id, group)
            end
          end,
        })

        return win.win
      end

      hover.config({
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

      -- Sort LSP providers to ensure main LSP is always the first tab
      local preferred_lsps = { "vtsls", "clangd", "lua_ls", "gopls", "rust_analyzer" }
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function()
          vim.schedule(function()
            local ok, lsp_group = pcall(require, "hover.providers.lsp")
            if ok and lsp_group and lsp_group.providers then
              table.sort(lsp_group.providers, function(a, b)
                local a_pref = 0
                local b_pref = 0
                for i, name in ipairs(preferred_lsps) do
                  if a.name == name then
                    a_pref = #preferred_lsps - i + 1
                  end
                  if b.name == name then
                    b_pref = #preferred_lsps - i + 1
                  end
                end
                if a_pref ~= b_pref then
                  return a_pref > b_pref
                end
                return a.name < b.name
              end)
            end
          end)
        end,
      })

      -- Setup keymaps
      vim.keymap.set("n", "K", require("hover").open, { desc = "hover.nvim" })
      vim.keymap.set("n", "<C-p>", function()
        require("hover").switch("previous")
      end, { desc = "hover.nvim (previous source)" })
      vim.keymap.set("n", "<C-n>", function()
        require("hover").switch("next")
      end, { desc = "hover.nvim (next source)" })

      -- Mouse support (optional, uncomment if desired)
      -- vim.keymap.set('n', '<MouseMove>', require('hover').hover_mouse, { desc = 'hover.nvim (mouse)' })
      -- vim.o.mousemoveevent = true
    end,
  },
}
