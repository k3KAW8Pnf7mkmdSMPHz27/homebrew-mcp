class EventkitMcpServer < Formula
  desc "MCP server exposing Apple Reminders via EventKit"
  homepage "https://github.com/k3KAW8Pnf7mkmdSMPHz27/EventKitMCP"
  url "https://github.com/k3KAW8Pnf7mkmdSMPHz27/EventKitMCP.git",
      using: :git,
      tag: "v1.0.0",
      revision: "dc1316c28099c4847dde9712a6b38b1736131370"
  license "AGPL-3.0-or-later"

  depends_on xcode: ["16.0", :build]
  depends_on :macos

  def install
    # The source keeps a placeholder version; releases are cut by tagging, so
    # the tag's version is written in here. inreplace fails if nothing matches.
    inreplace "Sources/EventKitService/EventKitService.swift",
              /eventKitServiceVersion = "[^"]*"/,
              "eventKitServiceVersion = \"#{version}\""
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/eventkit-mcp-server"
  end

  test do
    assert_match "eventkit-mcp-server", shell_output("#{bin}/eventkit-mcp-server --help", 0)
    assert_equal version.to_s, shell_output("#{bin}/eventkit-mcp-server --version").strip
  end
end
