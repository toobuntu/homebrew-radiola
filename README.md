<!--
SPDX-FileCopyrightText: Copyright 2025 Todd Schulman

SPDX-License-Identifier: GPL-3.0-or-later
-->

<a href="https://github.com/SokoloffA/radiola">
  <img src="docs/assets/signal.svg" width="128" alt="Radiola logo">
</a>

<!--
[![radiola](docs/assets/radiola.png)](https://github.com/SokoloffA/radiola)
-->

# Radiola 8 Legacy Tap

This tap provides the legacy **Radiola 8** release.

Radiola 8 was the final release that used macOS’ built‑in **AVPlayer** audio engine. 
Newer Radiola versions switched to an FFmpeg-based engine to support more audio formats and address issues with certain streams, which increased the application’s size and memory usage.

Radiola 8 remains useful for playing simple MP3/AAC streams using only macOS’ built-in media frameworks, with slightly lower runtime memory usage (≈ 12–32 MB v. ≈ 27–40 MB as of December 2025).

Installing Radiola 8 from this tap also prevents it from auto-updating to the newer audio engine. 
If you want to follow ongoing upstream development, install Radiola from its official Homebrew cask instead.

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

To ensure Radiola 8 does not prompt for newer versions, the cask automatically:

- disables automatic update checks
- points Sparkle (the in-app updater) to a custom update feed pinned to Radiola 8

You can also disable updates manually:

```sh
defaults write ~/Library/Preferences/com.github.SokoloffA.Radiola.plist SUEnableAutomaticChecks -bool false
defaults write ~/Library/Preferences/com.github.SokoloffA.Radiola.plist SUFeedURL -string "https://raw.githubusercontent.com/toobuntu/homebrew-radiola/main/feed.xml"
```

## Technical notes

See [NOTES.md](docs/NOTES.md) for details on:

- Sparkle updater behavior
- Further blocking the update server via DNS as a fallback

## Acknowledgments

Radiola was created by Alexander Sokolov. 
You can support the project by starring or watching the upstream repository: 
https://github.com/SokoloffA/radiola

## License

[GPL-3.0-or-later](LICENSE) Copyright Todd Schulman

Third-party assets include their own license information.
