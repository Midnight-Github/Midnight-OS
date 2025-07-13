# Midnight-OS

Midnight-OS is a modular, extensible operating system for [CC: Tweaked](https://tweaked.cc/) in Minecraft, designed for use with ComputerCraft computers. It features a modern UI, app framework, and utilities for both end-users and developers.

## Features

- **Modern UI**: Built with the Basalt UI library for a windowed, interactive experience.
- **App Ecosystem**: Includes built-in apps such as Calculator, Terminal, Chat, Info, and Waystone.
- **Extensible**: Easily add or develop new apps and utilities.
- **Rednet & Peripheral Support**: Integrates with modems, speakers, and other peripherals.
- **Settings & Config**: User-friendly configuration and persistent settings.
- **File Management**: Safe file access and archiving utilities.
- **Developer Tools**: Includes upload scripts and api tools.

## Directory Structure

```
midnightos.lua                # Main OS launcher
startup.lua                   # Startup script
midnightos_installer.lua      # Installer script
midnightos_uninstaller.lua    # Uninstaller script
about.txt                     # About info
os/
  config.lua                  # User and system config
  const.lua                   # Constants
  lib/
    api.lua                   # API for config and system functions
    ext.lua                   # Utility functions (math, string, file, etc.)
    gps.lua                   # GPS utilities
    metrics.lua               # Data processing
    basalt/
      bext.lua                # Basalt UI extensions
      main.lua                # Basalt UI library
  app/
    calculator.lua            # Calculator app
    chat.lua                  # Chat app (with user/message storage)
    info.lua                  # Info dashboard app
    terminal.lua              # Terminal emulator app
    waystone.lua              # Waystone navigation app (WIP)
  appdata/                    # App data storage (chat users/messages, etc.)
```

## Installation

1. **Enable HTTP API** in your CC: Tweaked config (`http.enabled=true`).
2. Download and run the installer:
   ```
   pastebin get 2SWPXJn8 midnightos_installer
   ```
   Or copy `midnightos_installer.lua` to your computer and run:
   ```
   midnightos_installer.lua
   ```
3. Follow the prompts to set up your display name and time zone.

## Usage

- The OS will launch automatically on startup.
- Use the app list to open Calculator, Chat, Info, Terminal, and other apps.
- Settings are accessible from the terminal app.
- Chat and other apps store data in `os/appdata/`.

## Development

- Apps are located in `os/app/`.
- Utilities and libraries are in `os/lib/`.
- The Basalt UI library is minified in `os/lib/basalt/main.lua`.

## Credits

- [Basalt UI Library](https://github.com/Pyroxenium/Basalt2)
- [CC: Tweaked](https://tweaked.cc/)
- Midnight-OS contributors: Midnight-Github

## License

See [LICENSE](LICENSE) (WIP) for details.
