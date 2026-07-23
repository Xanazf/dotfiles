-- disable spell for markdown and mdx
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "mdx" },
  callback = function(_)
    vim.wo.spell = false
  end,
  group = vim.api.nvim_create_augroup("MarkdownGlobalNoSpell", { clear = true }),
})

vim.filetype.add({
  extension = {
    -- HLSL (High-Level Shader Language)
    hlsl = "hlsl",
    fx = "hlsl",
    fxh = "hlsl",
    hlsli = "hlsl",

    -- GLSL (OpenGL Shading Language)
    glsl = "glsl",
    frag = "glsl",
    vert = "glsl",
    geom = "glsl",
    comp = "glsl",
    tesc = "glsl",
    tese = "glsl",
    mesh = "glsl",
    task = "glsl",

    -- Go Templates
    gotmpl = "gotmpl",
    gohtml = "gotmpl",
    tmpl = "gotmpl",

    -- Other useful extensions
    mdx = "markdown",
    mjml = "xml",
  },

  filename = {
    -- Hyprland
    ["hyprland.conf"] = "hyprlang",

    -- JSON with Comments (JSONC) for TS/JS ecosystems
    ["tsconfig.json"] = "jsonc",
    [".eslintrc.json"] = "jsonc",
    ["jsconfig.json"] = "jsonc",

    -- Miscellaneous
    ["Vagrantfile"] = "ruby",
    ["Dockerhtml"] = "dockerfile",
  },

  pattern = {
    -- match generic configuration files under hypr directory
    [".*/hypr/.*%.conf"] = "hyprlang",

    -- match dot files like .env.local, .env.development as sh/dotenv
    ["%.env%.%.*"] = "sh",

    -- distinguish Helm/Go templates from standard YAML
    [".*/templates/.*%.yaml"] = function(path, bufnr)
      local first_line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ""
      if first_line:match("{{.*}}") or first_line:match("^#") then
        return "gotmpl"
      end
      return "yaml"
    end,
  },
})

-- color scheme util
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("transparent_fixes", { clear = true }),
  ---@param args {buf: number, event: string, file: string, group: number, id: number, match: string}
  callback = function(args)
    ---@type table<string, string>
    local colors = {
      bg = vim.fn.synIDattr(vim.fn.hlID("Normal"), "bg"),
      fg = vim.fn.synIDattr(vim.fn.hlID("Normal"), "fg"),

      hint = "#7f6600",
      hint_bg = "#2f4053", -- TODO: make prefer transparent
      tsblue = "#3178C6",

      blue = "#61afef",
      green = "#72f1b8",
      purple = "#af6df9",
      cyan = "#61e2ff",
      l_red = "#e06c75",
      red = "#fe4450",
      yellow = "#ffcc00",
      orange = "#ff8b39",
      orange_bg = "#473336",
      gray = "#5c6370",
      dark = "#090639",
      light = "#8ba7a7",
    }
    -- e.g.: cterm=bold gui=bold,nocombine guifg=#ffcc00 guibg=#262335

    -- vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal", default = false })
    --
    -- vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = colors.blue, bg = colors.bg })
    -- vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = colors.cyan, bg = colors.bg })
    vim.api.nvim_set_hl(0, "FloatBorder", { fg = colors.cyan, bg = colors.bg, bold = true })
    vim.api.nvim_set_hl(0, "Pmenu", { link = "Normal", bold = true })
    vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { link = "FloatBorder" })
    vim.api.nvim_set_hl(0, "PmenuExtra", { link = "Function", default = false })

    -- mini.icons
    vim.api.nvim_set_hl(0, "MiniIconsOrange", { fg = colors.orange, bg = colors.bg })
    vim.api.nvim_set_hl(0, "MiniIconsYellow", { fg = colors.yellow, bg = colors.bg })
    vim.api.nvim_set_hl(0, "MiniIconsAzure", { fg = colors.tsblue, bg = colors.bg })
    vim.api.nvim_set_hl(0, "MiniIconsBlue", { fg = colors.blue, bg = colors.bg })
    vim.api.nvim_set_hl(0, "MiniIconsCyan", { fg = colors.cyan, bg = colors.bg })
    -- vim.api.nvim_set_hl(0, "MiniIconsRed", { fg = colors.red, bg = colors.bg })

    -- mini.hipatterns
    vim.api.nvim_set_hl(0, "MiniHipatternsNote", { fg = colors.dark, bg = colors.blue, bold = true })
    vim.api.nvim_set_hl(0, "MiniHipatternsTodo", { fg = colors.dark, bg = colors.cyan, bold = true })
    vim.api.nvim_set_hl(0, "MiniHipatternsHack", { fg = colors.dark, bg = colors.orange, bold = true })
    vim.api.nvim_set_hl(0, "MiniHipatternsFixme", { fg = colors.dark, bg = colors.l_red, bold = true })
    vim.api.nvim_set_hl(0, "MiniHipatternsBug", { fg = colors.dark, bg = colors.red, bold = true })

    -- render-mark
    vim.api.nvim_set_hl(0, "RenderMarkdownH4Bg", { link = "DiagnosticVirtualTextOk", default = false })

    -- symbolsline
    -- vim.api.nvim_set_hl(0, "NavicText", { link = "String" })
  end,
})
