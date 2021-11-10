class Docutils < Formula
  include Language::Python::Virtualenv

  desc "Text processing system for reStructuredText"
  homepage "https://docutils.sourceforge.io"
  url "https://downloads.sourceforge.net/project/docutils/docutils/0.18/docutils-0.18.tar.gz"
  sha256 "c1d5dab2b11d16397406a282e53953fe495a46d69ae329f55aa98a5c4e3c5fbb"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff5b2092cbe68edf0834516ce550deb95a244274d5a09f858b23e5aecd5a1dad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff5b2092cbe68edf0834516ce550deb95a244274d5a09f858b23e5aecd5a1dad"
    sha256 cellar: :any_skip_relocation, monterey:       "0188bab1d52fd5ad0a96332e696255b1a0dadc212c5150a4084e8323db2fc590"
    sha256 cellar: :any_skip_relocation, big_sur:        "0188bab1d52fd5ad0a96332e696255b1a0dadc212c5150a4084e8323db2fc590"
    sha256 cellar: :any_skip_relocation, catalina:       "0188bab1d52fd5ad0a96332e696255b1a0dadc212c5150a4084e8323db2fc590"
    sha256 cellar: :any_skip_relocation, mojave:         "0188bab1d52fd5ad0a96332e696255b1a0dadc212c5150a4084e8323db2fc590"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd5fa6462de930acd899147e725e59693d28089741f330ffa1cb559f66f19bed"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources

    Dir.glob("#{libexec}/bin/*.py") do |f|
      bin.install_symlink f => File.basename(f, ".py")
    end
  end

  test do
    system "#{bin}/rst2man.py", "#{prefix}/HISTORY.txt"
  end
end
