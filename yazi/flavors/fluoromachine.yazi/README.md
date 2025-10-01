# Fluoromachine.yazi

A Yazi flavor based on the [Fluoromachine](https://github.com/maxmx03/fluoromachine.nvim) Neovim colorscheme by maxmx03.

## Description

Fluoromachine is a synthwave-inspired colorscheme with neon colors and a retro-futuristic aesthetic. This Yazi flavor brings the same vibrant colors and cyberpunk feel to your file manager experience.

## Color Palette

- **Background**: `#262335` (Dark purple-gray)
- **Foreground**: `#8BA7A7` (Light blue-gray)
- **Accent Colors**:
  - Cyan: `#61E2FF`
  - Green: `#72F1B8`
  - Orange: `#FF8B39`
  - Pink: `#FC199A`
  - Purple: `#AF6DF9`
  - Red: `#FE4450`
  - Yellow: `#FFCC00`

## Features

- Synthwave-inspired neon color scheme
- High contrast for better readability
- Consistent color coding for different file types
- Custom icons for common development files and directories
- Optimized for both light and dark terminal backgrounds

## Installation

### Using ya pkg (Recommended)

```bash
ya pack -a fluoromachine.yazi
```

### Manual Installation

1. Clone or download this flavor to your Yazi flavors directory:
   ```bash
   git clone https://github.com/your-username/fluoromachine.yazi ~/.config/yazi/flavors/fluoromachine.yazi
   ```

2. Add the flavor to your `theme.toml`:
   ```toml
   [flavor]
   dark = "fluoromachine"
   ```

## Usage

After installation, the flavor will be automatically applied when you restart Yazi. The flavor includes:

- Vibrant syntax highlighting for code previews
- Color-coded file types (images in yellow, videos in pink, archives in orange, etc.)
- Neon-themed UI elements with high contrast
- Custom icons for development-related files and directories

## Compatibility

This flavor is compatible with Yazi v0.2.4 and later versions that support the flavor system.

## Credits

- Original Fluoromachine colorscheme by [maxmx03](https://github.com/maxmx03)
- Inspired by the synthwave aesthetic and retro-futuristic design
- Adapted for Yazi by the community

## License

MIT License - see the original [Fluoromachine repository](https://github.com/maxmx03/fluoromachine.nvim) for details.
