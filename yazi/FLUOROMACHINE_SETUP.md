# 🌈 Yazi Fluoromachine Configuration Setup

Your Yazi configuration has been successfully updated with the **Fluoromachine** theme and modern development-focused features!

## 🎨 What's New

### Fluoromachine Theme
- **Custom Yazi flavor** based on the popular [Fluoromachine Neovim colorscheme](https://github.com/maxmx03/fluoromachine.nvim)
- **Synthwave aesthetic** with neon colors and retro-futuristic design
- **High contrast** for better readability
- **Color-coded file types** for quick visual identification

### Color Palette
- **Background**: `#262335` (Dark purple-gray)
- **Foreground**: `#8BA7A7` (Light blue-gray)
- **Accents**: Neon cyan, pink, purple, yellow, green, orange, and red

## 📁 Files Updated/Created

### Core Configuration
- `yazi.toml` - Updated with modern settings (mgr section, scrolloff, etc.)
- `theme.toml` - Configured to use Fluoromachine flavor
- `keymap.toml` - Added development-focused keybindings
- `package.toml` - Updated with useful plugins for development and media
- `init.lua` - Custom linemode showing file size and modification time

### Fluoromachine Flavor
- `flavors/fluoromachine.yazi/flavor.toml` - Complete theme configuration
- `flavors/fluoromachine.yazi/tmtheme.xml` - Syntax highlighting theme
- `flavors/fluoromachine.yazi/README.md` - Documentation
- `flavors/fluoromachine.yazi/LICENSE` - MIT license
- `flavors/fluoromachine.yazi/LICENSE-tmtheme` - tmTheme license

## 🔧 Features Added

### Plugins (via package.toml)
- **Media plugins**: mediainfo, ouch (archives), torrent-preview
- **Development plugins**: git, diff, chmod, smart-enter, smart-filter, smart-paste
- **Navigation**: jump-to-char, vcs-files
- **UI enhancements**: full-border, toggle-pane
- **Development tools**: types.yazi for Lua API

### Keybindings (keymap.toml)
- `g + s/l/d/f` - Git operations (status, log, diff, changed files)
- `<Enter>` - Smart enter (files/directories)
- `/` - Smart filter
- `p` - Smart paste
- `f` - Jump to character
- `c + h` - Change permissions
- `T + b/p` - Toggle UI elements
- `C` - Compress with ouch
- `Ctrl+g/t/e` - Git status, tig, edit directory

### File Type Colors
- 📁 **Directories**: Cyan
- 🖼️ **Images**: Yellow
- 🎥 **Videos/Audio**: Pink
- 📦 **Archives**: Orange
- 📄 **Documents**: Red
- 💻 **Code files**: Language-specific neon colors

## 🚀 How to Use

1. **Restart Yazi** to apply the new configuration:
   ```bash
   yazi
   ```

2. **Install plugins** (if needed):
   ```bash
   ya pkg install
   ```

3. **Enjoy the new look!** The Fluoromachine theme will be automatically applied.

## 🎯 Key Improvements

### Modern Configuration
- Updated from `[manager]` to `[mgr]` (latest format)
- Added `scrolloff = 5` for better navigation
- Custom linemode showing file size and modification time
- Improved task management settings

### Development Focus
- Git integration with visual indicators
- Smart file operations
- Archive handling with ouch
- Media file previews
- Syntax highlighting with Fluoromachine colors

### Visual Enhancements
- Neon color scheme with high contrast
- Custom icons for development files
- Consistent color coding across file types
- Retro-futuristic aesthetic

## 🔍 File Structure

```
~/.config/yazi/
├── yazi.toml           # Main configuration
├── theme.toml          # Flavor selection
├── keymap.toml         # Custom keybindings
├── package.toml        # Plugin dependencies
├── init.lua            # Custom functions
├── flavors/
│   └── fluoromachine.yazi/
│       ├── flavor.toml     # Theme colors and styles
│       ├── tmtheme.xml     # Syntax highlighting
│       ├── README.md       # Documentation
│       ├── LICENSE         # MIT license
│       └── LICENSE-tmtheme # tmTheme license
└── plugins/            # Existing plugins
    ├── mediainfo.yazi/
    ├── ouch.yazi/
    └── torrent-preview.yazi/
```

## 🎉 Enjoy Your New Setup!

Your Yazi file manager now features:
- ✨ Stunning Fluoromachine synthwave theme
- 🛠️ Development-focused plugins and keybindings
- 🎨 Modern configuration with latest Yazi features
- 📱 Consistent visual experience across all file types

The configuration is fully compatible with Yazi v0.2.4+ and follows the latest documentation standards as of September 2025.

Happy file managing! 🚀