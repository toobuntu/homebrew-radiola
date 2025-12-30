# SPDX-FileCopyrightText: Copyright 2025 Todd Schulman
#
# SPDX-License-Identifier: GPL-3.0-or-later

cask "radiola@8" do
  version "8.1.1"
  sha256 "22d681c31fe172ec7d2e493446f457f70cbd3026eed224527a45a27df632d394"

  url "https://github.com/SokoloffA/radiola/releases/download/v#{version}/Radiola-#{version}.dmg"
  name "Radiola"
  desc "Internet radio player for the menu bar"
  homepage "https://github.com/SokoloffA/radiola"

  livecheck do
    skip "Last legacy version prior to audio engine change"
  end

  auto_updates true
  conflicts_with cask: "radiola"
  depends_on macos: ">= :big_sur"

  app "Radiola.app"

  # Legacy version; disable Sparkle updates
  postflight do
    prefs = File.expand_path("~/Library/Preferences/com.github.SokoloffA.Radiola.plist")
    feed_url = "https://raw.githubusercontent.com/toobuntu/homebrew-radiola/main/feed.xml"

    ohai "Preparing Radiola 8 to suppress update checks..."

    system_command "/usr/bin/pkill",
                   args:         ["-f", "Radiola.app/Contents/MacOS/Radiola"],
                   must_succeed: false

    # Disable Sparkle Updater's automatic checks
    set_result = system_command "/usr/libexec/PlistBuddy",
                                args:         ["-c", "Set :SUEnableAutomaticChecks false", prefs],
                                must_succeed: false,
                                print_stderr: false

    unless set_result.success?
      add_result = system_command "/usr/libexec/PlistBuddy",
                                  args:         ["-c", "Add :SUEnableAutomaticChecks bool false", prefs]
      if !add_result.success? && add_result.stderr.exclude?("Entry Already Exists")
        opoo "Failed to write SUEnableAutomaticChecks to #{prefs}: #{add_result.stderr}"
      end
    end

    # Point Sparkle to a custom feed
    set_result = system_command "/usr/libexec/PlistBuddy",
                                args:         ["-c", "Set :SUFeedURL #{feed_url}", prefs],
                                must_succeed: false,
                                print_stderr: false

    unless set_result.success?
      add_result = system_command "/usr/libexec/PlistBuddy",
                                  args:         ["-c", "Add :SUFeedURL string #{feed_url}", prefs]
      if !add_result.success? && add_result.stderr.exclude?("Entry Already Exists")
        opoo "Failed to write SUFeedURL to #{prefs}: #{add_result.stderr}"
      end
    end
  end

  uninstall_postflight do
    prefs = File.expand_path("~/Library/Preferences/com.github.SokoloffA.Radiola.plist")

    next unless File.exist?(prefs)

    puts <<~MSG
      ==> Unsuppressing Radiola updates in:
        ~/Library/Preferences/com.github.SokoloffA.Radiola.plist
    MSG

    system_command "/usr/bin/pkill",
                   args:         ["-f", "Radiola.app/Contents/MacOS/Radiola"],
                   must_succeed: false

    del_result = system_command "/usr/libexec/PlistBuddy",
                                args:         ["-c", "Delete :SUEnableAutomaticChecks", prefs],
                                must_succeed: false

    if !del_result.success? && del_result.stderr.exclude?("Does Not Exist")
      $stderr.puts "==> Failed to delete SUEnableAutomaticChecks: #{del_result.stderr}"
    end

    del_result = system_command "/usr/libexec/PlistBuddy",
                                args:         ["-c", "Delete :SUFeedURL", prefs],
                                must_succeed: false

    if !del_result.success? && del_result.stderr.exclude?("Does Not Exist")
      $stderr.puts "==> Failed to delete SUFeedURL: #{del_result.stderr}"
    end
  end

  uninstall quit: "com.github.SokoloffA.Radiola"

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.github.sokoloffa.radiola.sfl*",
    "~/Library/Application Support/com.github.SokoloffA.Radiola",
    "~/Library/Application Support/Radiola",
    "~/Library/Caches/com.github.SokoloffA.Radiola",
    "~/Library/HTTPStorages/com.github.SokoloffA.Radiola",
    "~/Library/HTTPStorages/com.github.SokoloffA.Radiola.binarycookies",
    "~/Library/Preferences/com.github.SokoloffA.Radiola.plist",
  ]

  caveats <<~EOS
    This legacy release of Radiola uses Apple’s AVPlayer. Updating the
    app will switch it to a different audio engine. This cask automatically
    configures Radiola so that update checks do not offer newer versions.

    Radiola also includes a setting to disable automatic update checks.
    As an optional fail‑safe, you may block IPv4 and IPv6 access to
    `sokoloffa.github.io` using a firewall or in /etc/hosts.

    For details, see:
      https://github.com/toobuntu/homebrew-radiola/blob/main/docs/NOTES.md
  EOS
end
