cask "test-radiola-debug" do
  version "1.0"
  sha256 :no_check
  url "file:///dev/null"
  name "Test"
  app "Radiola.app"

  postflight do
    ohai "postflight running"
    system_command "/usr/bin/true", args: [], must_succeed: false
  end
end
