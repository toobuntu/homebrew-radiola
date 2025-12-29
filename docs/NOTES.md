<!--
  Radiola 8 is the last release to use Apple’s AVPlayer framework
  for audio playback. To keep AVPlayer, do not allow the app to update.

  Radiola checks for updates using a hardcoded Sparkle appcast feed, and
  will offer to update unless that feed is blocked.

  To make it easier to stay on Radiola 8, block both IPv4 and IPv6 access
  to `sokoloffa.github.io` using your preferred firewall or DNS method.
-->

# Radiola 8 (Legacy) – Technical Notes

This tap provides Radiola 8.1.1, the final release that used macOS’s built‑in AVPlayer framework for audio playback. Later versions migrated to an FFmpeg‑based engine to support additional codecs (e.g., FLAC) and to improve metadata handling for certain streams.

Radiola 8 remains useful for users whose needs are met by simple MP3/AAC radio streams and who prefer the lower memory usage of the AVPlayer-based engine. This tap exists to make that legacy version easily installable without interfering with the official Radiola cask.

## Sparkle Updater Behavior

Radiola uses Sparkle for updates, which checks a hardcoded appcast feed. To prevent Radiola 8 from offering newer versions, the cask:

- disables automatic update checks (`SUEnableAutomaticChecks`)
- overrides the feed URL (`SUFeedURL`)

These keys are removed during uninstall.

This approach avoids accidental upgrades while keeping Radiola functional.

## Blocking the Update Feed

This tap provides a custom Sparkle appcast feed pinned to Radiola 8. As a fallback in case the Radiola preferences file, `~/Library/Preferences/com.github.SokoloffA.Radiola.plist`, gets corrupted or reset to its defaults, you may block access to:
  `sokoloffa.github.io`

Blocking must cover both IPv4 and IPv6. Some systems prefer IPv6 or bypass `/etc/hosts` due to DNS caching.

Blocking the update feed is not the only way to stay on Radiola 8, but it is the most reliable way to avoid accidental upgrades.

Example `/etc/hosts` entries (optional):

```sh
0.0.0.0 sokoloffa.github.io  # IPv4 blackhole
::1     sokoloffa.github.io  # IPv6 loopback
```

A per‑app outbound firewall (e.g., Little Snitch, LuLu, Radio Silence) or a DNS rule is generally more reliable than editing `/etc/hosts`.

## Scope of This Tap

- Provides **only** Radiola 8.1.1 (AVPlayer-based).
- Does **not** modify Radiola’s internal update mechanism.
- Does **not** install system-level blocks or launchd jobs.
- Does **not** track or package newer Radiola releases.

Users who want newer versions should install Radiola from the official Homebrew cask.

## Upstream Project

Radiola is developed by its upstream author. You can support the project by starring or watching the repository:

https://github.com/SokoloffA/radiola
