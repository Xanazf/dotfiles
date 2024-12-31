return {
  "mfussenegger/nvim-lint",
  opts = {
    linters_by_ft = {
      --- qml = { "qmllint" },
    },
    ---@type table<string,table>
    linters = {
      --- qmllint = {
      --- cmd = "qmllint",
      --- stdin = false,
      ---},
    },
  },
}
