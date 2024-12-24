cask "test-radiola" do
  version "7.0.2"
  sha256 "834d07f0e55ea874e1270284745123c3d6b312a2618ed5235fb0d5290f8f31e9"

  url "https://github.com/SokoloffA/radiola/releases/download/v#{version}/Radiola-#{version}.dmg"
  # NOTE: When a GitHub release tag is in MAJOR.MINOR.PATCH format, use
  # url "https://github.com/SokoloffA/radiola/releases/download/v#{version}/Radiola-#{version}.dmg"
  # NOTE: When a GitHub release tag is in MAJOR.MINOR format, use
  # url "https://github.com/SokoloffA/radiola/releases/download/v#{version.major_minor}/Radiola-#{version}.dmg"
  name "Radiola"
  desc "Internet radio player for the menu bar"
  homepage "https://github.com/SokoloffA/radiola"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "Radiola.app"

  uninstall quit: "com.github.SokoloffA.Radiola"

  zap trash: [
    "~/Library/Application Support/com.github.SokoloffA.Radiola",
    "~/Library/Caches/com.github.SokoloffA.Radiola",
    "~/Library/HTTPStorages/com.github.SokoloffA.Radiola",
    "~/Library/Preferences/com.github.SokoloffA.Radiola.plist",
    "~/Library/WebKit/com.github.SokoloffA.Radiola",
  ]
end
