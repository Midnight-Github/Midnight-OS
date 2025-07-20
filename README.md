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

## Directory Structure

```
midnightos.lua                # Main OS launcher
startup.lua                   # Startup script
installer.lua                 # Installer script
uninstaller.lua               # Uninstaller script
about.txt                     # About info
dev/
  upload/
    main.lua                  # Upload utility
os/
  config.lua                  # User and system config
  const.lua                   # Constants
  lib/
    api.lua                   # API for config and system functions
    ext.lua                   # Utility functions (math, string, file, etc.)
    metrics.lua               # Data processing
    basalt/
      bext.lua                # Basalt UI extensions
      main.lua                # Basalt UI library
  app/
    calculator/
      main.lua                # Calculator app
    chat/
      main.lua                # Chat app (with user/message storage)
    info/
      main.lua                # Info dashboard app
    terminal/
      main.lua                # Terminal emulator app
    waystone/
      main.lua                # Waystone navigation app (WIP)
```

## Installation

1. **Enable HTTP API** in your CC: Tweaked config (`http.enabled=true`).
2. Type lua in your terminal and run the following code:
   ```
   file = fs.open("installer.lua", "w") file.write(http.get("https://raw.githubusercontent.com/Midnight-Github/Midnight-OS/refs/heads/main/installer.lua").readAll()) file.close() shell.run("installer.lua")
   ```
   Or download and run `installer.lua` in your computer:
3. Follow the prompts to set up your display name and time zone.

## Usage

- The OS will launch automatically on startup.
- Use the app list to open Calculator, Chat, Info, Terminal, and other apps.
- Settings are accessible from the terminal app at `os/config.lua` for now.
- Apps usually store data in `os/appdata/`.

## Development

- Apps are located in `os/app/`.
- Utilities and libraries are in `os/lib/`.
- The Basalt UI library is located at `os/lib/basalt/main.lua`.

## Uninstallation

To completely remove Midnight-OS from your computer:

1. Run the uninstaller from terminal:
   ```
   uninstaller.lua
   ```
2. Confirm the prompt to proceed.
3. The script will delete all Midnight-OS files and folders except the installer.

**Warning:** This action is irreversible and will remove all OS files, including any data stored in `os/appdata/`.

## Credits

- [Basalt UI Library](https://github.com/Pyroxenium/Basalt2)
- [CC: Tweaked](https://tweaked.cc/)
- Midnight-OS contributors: Midnight-Github

## License

See [LICENSE](LICENSE) (WIP) for details.
