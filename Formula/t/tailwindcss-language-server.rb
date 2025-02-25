class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https://github.com/tailwindlabs/tailwindcss-intellisense/tree/HEAD/packages/tailwindcss-language-server"
  url "https://github.com/tailwindlabs/tailwindcss-intellisense/archive/refs/tags/v0.14.7.tar.gz"
  sha256 "9b5c286505d811c405ea5bd64ad52489cc24b0e5157e8180009ead1ebd3f1757"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/@tailwindcss/language-server/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0afc09e041a5b26e5b3fe07b24b18e68323dd5ffc581222761319fd8a0b92c23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0afc09e041a5b26e5b3fe07b24b18e68323dd5ffc581222761319fd8a0b92c23"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0afc09e041a5b26e5b3fe07b24b18e68323dd5ffc581222761319fd8a0b92c23"
    sha256 cellar: :any_skip_relocation, sonoma:        "0afc09e041a5b26e5b3fe07b24b18e68323dd5ffc581222761319fd8a0b92c23"
    sha256 cellar: :any_skip_relocation, ventura:       "0afc09e041a5b26e5b3fe07b24b18e68323dd5ffc581222761319fd8a0b92c23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd571e81ddc3f0b1ddc6caf3828b218ab9286afd8445e25bda870b1bae506dc0"
  end

  depends_on "pnpm" => :build
  depends_on "node"

  def install
    cd "packages/tailwindcss-language-server" do
      system "pnpm", "install", "--frozen-lockfile"
      system "pnpm", "run", "build"
      bin.install "bin/tailwindcss-language-server"
    end
  end

  test do
    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    Open3.popen3(bin/"tailwindcss-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
