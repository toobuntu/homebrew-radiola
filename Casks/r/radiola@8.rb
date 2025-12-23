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
  depends_on macos: ">= :big_sur"

  app "Radiola.app"

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
  Radiola 8 is the last release that uses Apple’s AVPlayer framework
  for audio playback. To keep AVPlayer, do not allow the app to update.

  Radiola checks for updates using a hardcoded Sparkle appcast feed, and
  will offer to update unless that feed is blocked. Sparkle-related
  Info.plist defaults (such as SUFeedURL) do not disable these checks.

  To make it easier to stay on Radiola 8, block both IPv4 and IPv6 access
  to `sokoloffa.github.io` using your preferred firewall or DNS method.

  `/etc/hosts` entries may not stop the update check if DNS caching
  interferes or if VPNs or other network tools bypass the hosts file.

  Example `/etc/hosts` entries (optional):
    0.0.0.0 sokoloffa.github.io  # IPv4 blackhole
    ::1     sokoloffa.github.io  # IPv6 loopback
  EOS
end
