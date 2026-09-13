# xCloud Dotfiles Settings

A powerful, interactive Bash utility to manage and toggle dotfile configurations. Built with [Gum](https://github.com/charmbracelet/gum), it provides a beautiful terminal UI to easily configure your system settings by overwriting files or safely replacing specific values. Also ships with a [Quickshell](https://quickshell.org/) GUI on top of the same profile format.

This is a personal fork of [mylinuxforwork/ml4w-dotfiles-settings](https://github.com/mylinuxforwork/ml4w-dotfiles-settings), rebranded and maintained independently by [xCloud](https://xcloud.gg). See [CREDITS.md](CREDITS.md) for full upstream attribution. It is the settings app used by [xc0sh/dotfiles](https://github.com/xc0sh/dotfiles), whose live profile lives at `~/.config/xcloud-dotfiles-settings/gg.xcloud.dotfiles/settings.json`.

## ✨ Features

* **Interactive UI**: Navigate through configuration groups and settings using a sleek terminal interface.
* **Smart Pre-selection**: Automatically detects your current configuration and pre-fills text fields or highlights the active option in menus.
* **Direct CLI Manipulation**: Quickly `get` or `set` values directly from the command line for easy integration into other scripts or keybindings.
* **Dynamic File/Folder Selection**: Automatically reads directories to populate selection menus with available files or folders.
* **Post-Execution Commands**: Run background commands (like restarting Waybar or Hyprland) automatically after a setting is changed.
* **Safe Execution**: Warns you in the UI if a target configuration file doesn't exist yet and prevents accidental ghost-file creation.
* **Smart Replacements**: Supports complete file overwriting, regex-based string replacement, and targeted replacements after specific checkpoints in a file.
* **Profile Support**: Keep multiple configuration profiles isolated in parallel.

## 📦 Prerequisites

Ensure you have the following installed on your system:

* `bash`
* `jq` (Command-line JSON processor)
* `gum` (A tool for glamorous shell scripts)
* `awk`

All four are already in [xc0sh/dotfiles](https://github.com/xc0sh/dotfiles)'s `setup/dependencies/packages` list.

## 🚀 Installation

Clone the repository and install it globally using `make` (all distros):

```bash
git clone https://github.com/xc0sh/xcloud-dotfiles-settings.git
cd xcloud-dotfiles-settings
make install
```

Or copy the following command into your terminal to install all dependencies and xCloud Dotfiles Settings in one step (supporting Arch, Fedora & openSUSE Tumbleweed):

```bash
bash <(curl -s https://raw.githubusercontent.com/xc0sh/xcloud-dotfiles-settings/main/setup.sh)
```

To uninstall:

```bash
make uninstall
```

## 🛠️ Usage

The application requires a profile to run. Settings for the profile are stored in `~/.config/xcloud-dotfiles-settings/<profile_name>/settings.json`. xCloud's own profile ID is `gg.xcloud.dotfiles`.

```bash
# Start the interactive menu for xCloud's profile
xcloud-dotfiles-settings gg.xcloud.dotfiles

# Create a new profile with the demo configuration
xcloud-dotfiles-settings --create myprofile

# Run in test mode (simulates changes without modifying files)
xcloud-dotfiles-settings --test gg.xcloud.dotfiles

# Set a value directly via CLI (bypasses the UI)
xcloud-dotfiles-settings --set --id toggle_dock --value false gg.xcloud.dotfiles

# Get a current value directly via CLI (Outputs raw string, perfect for piping/variables)
xcloud-dotfiles-settings --get --id toggle_dock gg.xcloud.dotfiles

# Show help menu
xcloud-dotfiles-settings --help

```

## ⚙️ Configuration (`settings.json`)

The UI and logic are entirely driven by a `settings.json` file located in your profile directory. Settings are organized into **Groups**.

### Example `settings.json`

```json
[
    {
        "group": "Desktop",
        "description": "General desktop environment settings",
        "settings": [
            {
                "name": "Show App Menu",
                "id": "show_app_menu",
                "instructions": "Do you want to show the app menu in the status bar?",
                "file": "~/.config/waybar/config",
                "type": "toggle",
                "mode": "replace",
                "match": ".*\"wlr/taskbar\"",
                "default": "    ",
                "true_value": "    ",
                "false_value": "    //",
                "post_command": "killall waybar; waybar > /dev/null 2>&1 &"
            },
            {
                "name": "Select Animation",
                "id": "variant_animation",
                "instructions": "Choose your preferred animation variant:",
                "folder": "~/.config/hypr/conf/animations",
                "file": "~/.config/hypr/conf/animations.conf",
                "type": "files",
                "mode": "replace",
                "match": "source = ~/.config/hypr/conf/animations/.*",
                "default": "default.conf"
            },
            {
                "name": "Select Waybar Theme",
                "id": "theme_folder",
                "instructions": "Choose your theme folder:",
                "folder": "~/.config/xcloud/settings/waybar_themes",
                "file": "~/.config/xcloud/settings/waybar_theme",
                "type": "folders",
                "mode": "overwrite",
                "default": "xcloud-glass-center",
                "post_command": "~/.config/waybar/launch.sh > /dev/null 2>&1 &"
            }
        ]
    },
    {
        "group": "Terminal",
        "description": "Alacritty terminal configuration",
        "settings": [
            {
                "name": "Terminal Font Size",
                "id": "term_font_size",
                "instructions": "Enter the font size for your terminal:",
                "file": "~/.config/alacritty/alacritty.toml",
                "type": "textfield",
                "mode": "replace",
                "match": "size = .*",
                "default": "12"
            },
            {
                "name": "Terminal Font Color",
                "id": "term_font_color",
                "instructions": "Enter the font color for your terminal:",
                "file": "~/.config/alacritty/alacritty.toml",
                "type": "textfield",
                "mode": "replace",
                "match": "fontcolor = .*",
                "default": "#FFFFFF",
                "checkpoint": "#Comment"
            }
        ]
    }
]

```

### 🎛️ Setting Types

* `toggle`: Prompts the user with a Yes/No choice.
* Defaults to writing `"true"` or `"false"`.
* *Optional:* You can map Yes/No to custom strings by providing `"true_value"` and `"false_value"` keys.


* `textfield`: Prompts the user to type a string. It will pre-fill with the currently active value if one is detected.
* `choose`: Prompts the user to select from an array provided in the `"options"` key.
* `files`: Dynamically reads and lists all files from a specified directory. **Requires the `"folder"` key in the JSON object** to define where to look.
* `folders`: Dynamically reads and lists all subdirectories from a specified directory. **Requires the `"folder"` key in the JSON object** to define where to look.

### 📝 Operation Modes

* `overwrite`: Completely replaces the contents of the target file with the new value.
* `replace`: Searches for the `"match"` string (as a regular expression) and replaces the wildcard `.*` with the new value. (e.g., `size = .*` becomes `size = 14`).
* **replace with checkpoint**: If a `"checkpoint"` string is provided alongside `"mode": "replace"`, the script will first locate the checkpoint line, and *then* replace the very next occurrence of the `"match"` string.

### ⚡ Additional Keys

* `post_command`: An optional shell command to execute in the background after successfully applying a setting (e.g., `"killall waybar; waybar > /dev/null 2>&1 &"`).
* `folder`: The target directory path required when using `files` or `folders` types.

## ✨ Quickshell UI

xCloud Dotfiles Settings ships with a [Quickshell](https://quickshell.org/)-based UI on top of the same profile format.

```bash
# Start Quickshell environment
PROFILE="gg.xcloud.dotfiles" qs -p $HOME/.local/share/xcloud-dotfiles-settings/quickshell &
```

## Toggle Settings Window
```bash
qs -p $HOME/.local/share/xcloud-dotfiles-settings/quickshell ipc call settings toggle
```

### Matugen Config

```toml
[templates.xcloud_dotfiles_settings]
input_path  = "./templates/colors.json"
output_path = "~/.local/share/xcloud-dotfiles-settings/colors/colors.json"
```

### Reload Theme
```bash
qs -p $HOME/.local/share/xcloud-dotfiles-settings/quickshell ipc call theme-manager reload
```

## 🤝 Contributing

The bash logic lives in `lib/utils.sh` (settings get/apply logic shared by the CLI menu and direct `--get`/`--set` calls). The Quickshell UI lives in `lib/quickshell/` (`SettingsApp/SettingsWindow.qml` renders the same `settings.json` profile the CLI reads; `CustomTheme/Theme.qml` mirrors the Material 3 color-property pattern used by [xc0sh/dotfiles](https://github.com/xc0sh/dotfiles)'s own Quickshell shell, fed from the same matugen-generated `colors.json`).
