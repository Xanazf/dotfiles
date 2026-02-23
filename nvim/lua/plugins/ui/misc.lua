return {
  ---@module "nvim-navic"
  {
    "SmiteshP/nvim-navic",
    enabled = false,
    lazy = true,
    init = function()
      vim.g.navic_silence = true
    end,
    opts = function()
      local micons_mod = MiniIcons or require("mini.icons")
      local micons = micons_mod.list("lsp")

      return {
        separator = ": ",
        highlight = true,
        depth_limit = 6,
        icons = micons,
        lazy_update_context = false,
        click = true,
      }
    end,
    config = function(_, opts)
      require("nvim-navic").setup(opts)
      Snacks.util.lsp.on(function(buffer, client)
        if client:supports_method("textDocument/documentSymbol") then
          require("nvim-navic").attach(client, buffer)
        end
      end)
    end,
  },
  ---@module "dropbar"
  {
    "Bekaboo/dropbar.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    opts = function()
      local sources = require("dropbar.sources")
      local utils = require("dropbar.utils")
      return {
        bar = {
          sources = function(buf, win)
            local symbols = {}
            if vim.bo[buf].ft == "markdown" then
              symbols = {
                sources.markdown,
              }
            elseif vim.bo[buf].buftype == "terminal" then
              symbols = {
                sources.terminal,
              }
            else
              symbols = {
                sources.lsp,
                sources.treesitter,
              }
            end

            -- Strict Structural Merging
            return {
              {
                get_symbols = function(buf_, win_, cursor)
                  local items = {}
                  vim.list_extend(items, sources.lsp.get_symbols(buf_, win_, cursor))
                  vim.list_extend(items, sources.treesitter.get_symbols(buf_, win_, cursor))

                  -- 1. Sort by range size (Establish natural nesting)
                  table.sort(items, function(a, b)
                    local a_size = (a.range["end"].line - a.range.start.line) * 1000 + (a.range["end"].character - a.range.start.character)
                    local b_size = (b.range["end"].line - b.range.start.line) * 1000 + (b.range["end"].character - b.range.start.character)
                    if a_size ~= b_size then return a_size > b_size end
                    return a.source == "lsp"
                  end)

                  -- 2. Deduplicate overlapping symbols (LSP vs TS)
                  local deduped = {}
                  for _, sym in ipairs(items) do
                    local dup_idx = nil
                    if #deduped > 0 then
                      local last = deduped[#deduped]
                      local is_same_line = last.range.start.line == sym.range.start.line
                      local is_near = math.abs(last.range.start.character - sym.range.start.character) < 10
                      if is_same_line and is_near then dup_idx = #deduped end
                    end
                    if dup_idx then
                      if sym.source == "lsp" then deduped[dup_idx] = sym end
                    else
                      table.insert(deduped, sym)
                    end
                  end

                  -- 3. Filter for Logical Path
                  local path = {}
                  for i, sym in ipairs(deduped) do
                    local kind = sym.kind or 0
                    local name = sym.name:lower()
                    local is_last = (i == #deduped)
                    
                    -- Structural check: Keep functions, classes, and control flow
                    local is_func = kind == 6 or kind == 12 or name:find("function") or name:find("=>")
                    local is_struct = kind == 5 or kind == 11 or sym.source == "treesitter" or 
                                      name:find("if") or name:find("for") or name:find("while") or name:find("switch")

                    if is_last or is_func or is_struct then
                      -- Clean icons for TS nodes (LSP nodes already have them)
                      if sym.source == "treesitter" then
                        if name:find("if") then sym.icon = "󰇉 "
                        elseif name:find("for") or name:find("while") then sym.icon = "󰑖 "
                        elseif name:find("switch") then sym.icon = "󰯄 "
                        end
                      end
                      
                      -- Clean name for the winbar
                      if is_last then
                        sym.name = sym.name:gsub("^async%s+", ""):gsub("^function%s+", ""):gsub("^const%s+", "")
                      end
                      
                      table.insert(path, sym)
                    end
                  end

                  if #path >= 8 then
                    local truncated = {}
                    for i = #path - 6, #path do table.insert(truncated, path[i]) end
                    return truncated
                  end
                  return path
                end,
              },
            }
          end,
        },
        sources = {
          path = {
            relative_to = function()
              return vim.fn.getcwd()
            end,
          },
        },
        icons = {
          kinds = {
            use_mini_icons = true,
            symbols = {}, -- Will be filled by mini.icons if use_mini_icons is true
          },
          ui = {
            bar = {
              separator = " ",
              extends = "…",
            },
          },
        },
      }
    end,
  },
  ---@module "treesitter-context"
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    opts = {
      max_lines = 3,
      min_window_height = 20,
      line_numbers = true,
      multiline_threshold = 1, -- Only show the first line of multi-line definitions
      trim_scope = "outer", -- Concatenate intermediate scopes
      mode = "cursor",
    },
    keys = {
      {
        "[c",
        function()
          require("nvim-treesitter-context").go_to_context(vim.v.count1)
        end,
        desc = "Jump to upper context",
      },
    },
  },
  ---@module "which-key"
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts_extend = { "spec" },
    ---@class wk.Opts
    opts = {
      preset = "modern",
      keys = {},
      delay = 500,
      ---@type wk.Win.opts
      win = {
        wo = {
          -- Use transparent float background by linking to Normal (no fill)
          winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
        },
      },
    },
  },
}
