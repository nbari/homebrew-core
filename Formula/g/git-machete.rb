class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://files.pythonhosted.org/packages/4e/56/534872867171dd33f8a4dbba755275e4cd12f361f51d3b8f731bb4ac1b91/git_machete-3.26.4.tar.gz"
  sha256 "36ca33e90c9664a2c595f29d3f91a62b5bdc9ed15f5ab8f2b748b9f0f997fefe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "de1076f70eb5d4179d6198db8c2c3104898a3c6cba361d71d98aa08d1774e474"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de1076f70eb5d4179d6198db8c2c3104898a3c6cba361d71d98aa08d1774e474"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de1076f70eb5d4179d6198db8c2c3104898a3c6cba361d71d98aa08d1774e474"
    sha256 cellar: :any_skip_relocation, sonoma:         "de1076f70eb5d4179d6198db8c2c3104898a3c6cba361d71d98aa08d1774e474"
    sha256 cellar: :any_skip_relocation, ventura:        "de1076f70eb5d4179d6198db8c2c3104898a3c6cba361d71d98aa08d1774e474"
    sha256 cellar: :any_skip_relocation, monterey:       "de1076f70eb5d4179d6198db8c2c3104898a3c6cba361d71d98aa08d1774e474"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "adcf5f84320425e22b27f78b45e6b2d0896be06fe83e6c57357d83a660a4d5dc"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources

    man1.install "docs/man/git-machete.1"

    bash_completion.install "completion/git-machete.completion.bash"
    zsh_completion.install "completion/git-machete.completion.zsh"
    fish_completion.install "completion/git-machete.fish"
  end

  test do
    system "git", "init"
    system "git", "config", "user.email", "you@example.com"
    system "git", "config", "user.name", "Your Name"
    (testpath/"test").write "foo"
    system "git", "add", "test"
    system "git", "commit", "--message", "Initial commit"
    system "git", "branch", "-m", "main"
    system "git", "checkout", "-b", "develop"
    (testpath/"test2").write "bar"
    system "git", "add", "test2"
    system "git", "commit", "--message", "Other commit"

    (testpath/".git/machete").write "main\n  develop"
    expected_output = "  main\n  |\n  | Other commit\n  o-develop *\n"
    assert_equal expected_output, shell_output("git machete status --list-commits")
  end
end
