# LSP Configuration Integration with LazyVim

This LSP configuration is designed to seamlessly integrate with LazyVim's default configuration while providing custom enhancements and overrides.

## Integration Strategy

### 1. **Merge, Don't Replace**
All configuration files use `opts` functions that merge with LazyVim's existing configuration using `vim.tbl_deep_extend("force", ...)`. This ensures:
- LazyVim's defaults are preserved
- Custom settings override LazyVim where they intersect
- New functionality is added without breaking existing features

### 2. **Conditional Loading**
- Parsers and tools are installed based on project context (detected file types)
- Language servers are conditionally enabled based on available executables
- Performance optimizations for large files

### 3. **Key Features**

#### **LSP (lsp.lua)**
- Extends LazyVim's nvim-lspconfig with custom server configurations
- Adds specialized setups for TypeScript/JavaScript, C/C++, Go, QML, etc.
- Maintains LazyVim's default diagnostics and inlay hints while adding custom settings

#### **Treesitter (treesitter.lua)**
- Merges custom parsers with LazyVim's defaults
- Auto-installs parsers when opening unsupported file types
- Adds performance optimizations for large files
- Maintains LazyVim's textobjects while adding custom ones

#### **Mason (mason.lua)**
- Extends LazyVim's tool installation with project-specific tools
- Conditional installation based on available system tools
- Deduplicates tools to avoid conflicts

#### **Misc (misc.lua)**
- Extends various LSP-related plugins (SchemaStore, VimTeX, clangd_extensions, etc.)
- Adds support for additional file types (Astro, QML, etc.)
- Configures none-ls/null-ls if available

### 4. **File Structure**
```
lua/plugins/lsp/
├── init.lua          # Main entry point, combines all configurations
├── lsp.lua           # LSP server configurations
├── treesitter.lua    # Treesitter and textobjects configuration
├── mason.lua         # Tool installation configuration
├── misc.lua          # Additional LSP-related plugins
├── helpers.lua       # Helper functions and server definitions
└── README.md         # This documentation
```

### 5. **Custom Enhancements**

#### **Automatic Treesitter Enabling**
- Treesitter is automatically enabled when buffers with supported filetypes are opened
- Missing parsers are auto-installed on demand
- Performance safeguards for large files

#### **Project-Aware Tool Installation**
- Tools are installed based on detected project types
- Conditional installation reduces bloat
- Supports multiple programming languages and frameworks

#### **Enhanced TypeScript/JavaScript Support**
- Uses vtsls instead of tsserver for better performance
- Custom key mappings for TypeScript-specific actions
- Proper JavaScript settings inheritance from TypeScript

#### **System Integration**
- Custom filetype associations for system configuration files
- Support for shell configurations (fish, hypr, etc.)
- QML and other specialized language support

### 6. **Usage**

This configuration is automatically loaded by LazyVim when placed in the `lua/plugins/` directory. No additional setup is required.

The configuration will:
1. Merge with LazyVim's existing LSP setup
2. Add custom servers and tools based on your system and projects
3. Provide enhanced functionality while maintaining LazyVim's defaults
4. Automatically adapt to different project types

### 7. **Customization**

To customize further:
- Modify `helpers.lua` to add new servers or tools
- Update parser lists in `helpers.lua` for new languages
- Add new setup functions in `lsp.lua` for specialized server configurations
- Extend tool lists in `mason.lua` for additional development tools

### 8. **Compatibility**

This configuration is designed to be:
- **Forward compatible**: Works with LazyVim updates
- **Backward compatible**: Doesn't break existing LazyVim functionality
- **Modular**: Individual components can be disabled or modified
- **Performance conscious**: Conditional loading and optimizations included