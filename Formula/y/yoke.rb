class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.11.3",
      revision: "27f594f147d868c256a4535817b186b84cc3a62f"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "819b6e9c6fd10367bfa26ea6d5e0388825889208bacefbe7261b66cf51561b5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07baadcd3d4f7381b18489b38e643449c474b2f4abebae0e225f7374df391fa1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "67a99a165f3f4f42898182af65db63589f4082cd2b6944c3e8364bcc6b953db7"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d84dc818f9f08faace63ab249c9aec8c3206fa5aacd287f6d48f1933f2fd2b7"
    sha256 cellar: :any_skip_relocation, ventura:       "7d6fac1aab3da3464e1a604f4bd71f8405e66b3faaec062301ca6953a29059bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37a6116cc125739c3c061d0a745724755c453d8ec80de756557a91816d192025"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/yoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}/yoke inspect 2>&1", 1)
  end
end
