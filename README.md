[![radiola](docs/assets/radiola.png)](https://github.com/SokoloffA/radiola)
# Radiola Legacy Tap

This tap provides the legacy **Radiola 8** release, the final version that used macOS’ built‑in **AVPlayer** audio engine. Newer Radiola versions switched to an FFmpeg-based engine to support more audio formats and address issues with certain streams.

Radiola 8 remains lightweight and efficient—using roughly **2 MiB** of memory compared to **~27 MiB** for the FFmpeg-based engine. If the AVPlayer-based version worked well for your needs, you can install it from this tap. It often performed reliably for simple MP3/AAC radio streams.

This tap installs Radiola 8 and prevents it from auto-updating to the newer audio engine. If you want to follow ongoing upstream development, install Radiola from its official Homebrew cask instead.

You can support the project by starring or watching the upstream repository: https://github.com/SokoloffA/radiola

## Install

First, make sure you have installed [Homebrew](https://brew.sh) if you haven't yet.

Install with a single command:

```sh
brew install --cask toobuntu/radiola/radiola@8
```

Or, if you prefer step-by-step:
```sh
# Add this tap (required only once)
brew tap toobuntu/radiola

# Install Radiola 8 from the tap
brew install --cask radiola@8
```

## Uninstall

Run one of the following:

```sh
# To uninstall and keep your settings
brew uninstall --cask radiola@8

# To uninstall and remove all settings and caches
brew uninstall --zap --cask radiola@8
```

## Preventing updates

The cask automatically:

- disables automatic update checks
- points Sparkle (in-app updater) to a custom update feed pinned to Radiola 8

You can also disable updates manually:

```sh
defaults write ~/Library/Preferences/com.github.SokoloffA.Radiola.plist SUEnableAutomaticChecks -bool false
defaults write ~/Library/Preferences/com.github.SokoloffA.Radiola.plist SUFeedURL -string "https://raw.githubusercontent.com/toobuntu/homebrew-radiola/main/feed.xml"
```

## Technical notes

See [NOTES.md](docs/NOTES.md) for details on:

- Sparkle updater behavior
- Further blocking the update server via DNS as a fallback
