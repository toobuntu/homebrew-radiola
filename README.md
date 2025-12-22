[![radiola](radiola.png)](https://github.com/SokoloffA/radiola)
# Radiola Legacy Tap

This tap provides the last version of Radiola (version 8) that used macOS’s built‑in AVPlayer audio engine. Upstream has since migrated to FFmpeg to address issues some users experienced with certain streams.

Radiola 8 remains useful for users whose needs are met by simple MP3/AAC radio streams and who prefer AVPlayer’s lower memory usage (~2 MiB) compared to FFmpeg (~27 MiB).

This tap provides only Radiola 8, the final release using AVPlayer.  If you want to follow ongoing upstream development, install Radiola from its official Homebrew cask instead.

You can support the project by starring or watching the upstream repository: https://github.com/SokoloffA/radiola

## Installation

First, make sure you have installed [`Homebrew`](https://brew.sh) if you haven't yet.

Install with a single command:

```sh
brew install --cask toobuntu/radiola/radiola@8
```

Or, if you prefer step-by-step:
```sh
# Add this tap (required only once)
brew tap toobuntu/radiola

# Install Radiola v8 from the tap
brew install --cask radiola@8
```

## Uninstall

Run one of the following:

```sh
# To uninstall and keep your configuration files
brew uninstall --cask radiola@8

# To uninstall and delete your configuration files
brew uninstall --zap --cask radiola@8
```

