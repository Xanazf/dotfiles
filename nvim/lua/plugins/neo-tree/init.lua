return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = function(_, opts)
    local function on_move(data)
      Snacks.rename.on_rename_file(data.source, data.destination)
    end
    local events = require("neo-tree.events")

    opts.event_handlers = opts.event_handlers or {}

    vim.list_extend(opts.event_handlers, {
      { event = events.FILE_MOVED, handler = on_move },
      { event = events.FILE_RENAMED, handler = on_move },
    })

    opts.open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "edgy" }
    opts.sync_root_with_cwd = true
    opts.respect_buf_cwd = true
    opts.update_focused_file = {
      enable = true,
      update_root = true,
    }

    opts.filesystem = {
      filtered_items = {
        visible = true,
        show_hidden_count = true,
        hide_dotfiles = false,
        hide_gitignored = false,
        never_show = {},
      },
    }
  end,
}
