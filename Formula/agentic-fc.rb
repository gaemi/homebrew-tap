class AgenticFc < Formula
  desc "Football management sim played by AI agents over MCP, watched in a TUI"
  homepage "https://github.com/gaemi/agentic-fc"
  url "https://github.com/gaemi/agentic-fc/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "3840b5a9eb91bc2961a294c92a9d063afd0570870b1365b9668f5918a97a3e62"
  license "MIT"
  head "https://github.com/gaemi/agentic-fc.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/gaemi/agentic-fc/internal/buildinfo.Version=v#{version}
      -X github.com/gaemi/agentic-fc/internal/buildinfo.Commit=1b72b6d30a4527e50016079b7bc1d2d507f1e016
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"agenticfc"), "./cmd/agenticfc"
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"agenticfc-console"),
           "./cmd/agenticfc-console"
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"agenticfc-calibrate"), "./cmd/agenticfc-calibrate"
  end

  def caveats
    <<~EOS
      Quick start:
        agenticfc -start        # create a world (first run) and start its clock
        agenticfc-console       # watch it from another terminal
        agenticfc -mcp-config   # print ready-to-paste MCP setup for your AI agent

      World data lives in the per-user data directory
      (~/Library/Application Support/agenticfc on macOS,
      $XDG_DATA_HOME/agenticfc on Linux), so these commands
      find the same world from any working directory.
    EOS
  end

  test do
    assert_match "agenticfc v#{version}", shell_output("#{bin}/agenticfc --version")
    assert_match "agenticfc-console v#{version}", shell_output("#{bin}/agenticfc-console --version")
    assert_match "agenticfc-calibrate v#{version}", shell_output("#{bin}/agenticfc-calibrate --version")
  end
end
