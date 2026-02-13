# Niri Scale Toggle Plugin

A quick-access Noctalia Shell plugin for toggling screen scale sizes in Niri. Perfect for adjusting display sizes based on comfort level—especially useful in the evening when eyes are tired.

## Features

✨ **Quick Scale Toggle** - Access 5 preset scale sizes from the top panel
- Default presets: 1.0x, 1.25x, 1.5x, 1.75x, 2.0x
- Fully customizable in plugin settings

🖥️ **Multi-Monitor Support** - Select which output to control
- Works with any Niri output name (eDP-1, HDMI-1, DP-1, etc.)
- Find available outputs: `niri-msg outputs`

⚡ **Real-time Scaling** - Changes take effect immediately
- Uses `niri-msg` for instant scale adjustments
- Manual config reload option available

🎨 **Integrated UI** - Seamless Noctalia Shell integration
- Matches your shell theme automatically
- Shows current scale in the panel

## Installation

### 1. Clone or Copy the Plugin

Option A: Direct installation
```bash
mkdir -p ~/.config/noctalia/plugins/niri-scale-toggle
cp -r ./* ~/.config/noctalia/plugins/niri-scale-toggle/
```

Option B: Via symlink (for development)
```bash
git clone <repo-url> ~/projects/niri-scale-toggle
ln -s ~/projects/niri-scale-toggle ~/.config/noctalia/plugins/niri-scale-toggle
```

### 2. Restart Noctalia Shell

Either restart the shell or reload plugins:
- **Full restart**: `niri-msg action quit && noctalia`
- **Plugin reload**: Enable hot-reload in Noctalia settings (if available)

### 3. Verify Installation

The plugin should appear in your Noctalia shell panel (top bar by default) showing something like `1.00x`.

## Configuration

### Scale Presets

Edit in Noctalia Settings → Plugins → Niri Scale Toggle:

1. Click each scale field to adjust the value
2. Values are shown as percentages (100 = 1.0x, 150 = 1.5x)
3. Changes take effect immediately

**Recommended presets for accessibility:**
- Minimal: 1.0x
- Comfortable: 1.25x - 1.5x
- Large text: 1.75x - 2.0x

### Output Selection

1. Check available outputs:
   ```bash
   niri-msg outputs
   ```
   Look for output names like `eDP-1`, `HDMI-1`, `DP-1`

2. In plugin settings, select your primary monitor

3. The plugin will apply scales only to that output

## Usage

### Quick Scale Toggle

1. **Click the scale indicator** in the panel (shows current scale like `1.50x`)
2. **Select desired scale** from the popup menu
3. **Scale applies instantly** to the selected output

### Manual Config Reload

If you manually edit your Niri config and want to apply changes:
1. Click the scale indicator
2. Select **Reload Config** at the bottom of the menu
3. Configuration will reload without restarting

## Troubleshooting

### Plugin Doesn't Appear

- Verify Noctalia is running: `ps aux | grep noctalia`
- Check plugin directory: `ls -la ~/.config/noctalia/plugins/niri-scale-toggle/`
- View Noctalia logs: Check your terminal or journal output

### Scale Changes Don't Apply

**Verify niri-msg is available:**
```bash
which niri-msg
niri-msg outputs  # Should list your displays
```

**Check current scale:**
```bash
niri-msg outputs  # Look for "scale" values
```

**Manual scale change (workaround):**
Edit `~/.config/niri/config.kdl` and update output blocks:
```kdl
output "eDP-1" {
    scale 1.5
}
```

Then reload: `niri-msg action reload-config`

### Wrong Output Selected

1. Run `niri-msg outputs` to find correct output name
2. Update plugin settings to match
3. Restart the plugin or reload Noctalia

## Technical Details

### How It Works

1. **Bar Widget** - Shows current scale and provides click access
2. **Popup Menu** - Lists configured scale presets
3. **Command Execution** - Runs `niri-msg output <name> scale <value>`
4. **Config Reload** - Optional manual reload via `niri-msg action reload-config`

### Files

- `main.qml` - Main plugin UI and logic
- `settings.qml` - Settings interface for configuration
- `manifest.json` - Plugin metadata

### Dependencies

- **Noctalia Shell** 1.0.0+
- **Niri** compositor with `niri-msg` command
- Qt 6.x (included with Noctalia)

## Advanced Configuration

### Custom Scale Presets

Edit the `scalePresets` array in `main.qml` (line ~8):

```qml
property var scalePresets: [0.75, 1.0, 1.25, 1.5, 1.75]
```

Then reload the plugin.

### Multiple Outputs

Current version supports one output at a time. To control multiple:
1. Duplicate the plugin for each output
2. Modify `currentOutput` in `main.qml`
3. Install as separate plugins

## Contributing

Found a bug? Want a feature?
- Create an issue with reproduction steps
- Include output of `niri-msg outputs`
- Share your Niri config (sanitized)

## License

MIT License - See LICENSE file

## Changelog

### v1.0.0 (Initial Release)
- Scale toggle widget in panel
- 5 configurable preset scales
- Multi-output support
- Settings interface
- Config reload option
- Full documentation
