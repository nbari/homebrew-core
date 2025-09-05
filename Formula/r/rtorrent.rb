class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://github.com/rakshasa/rtorrent/releases/download/v0.16.0/rtorrent-0.16.0.tar.gz"
  sha256 "fe8f8793f3bae8de157f567d9d89629dfd6fc21bc18d7db4537c4014a23dc1d9"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "49b26ce0b9fe05cabc8b5ae3802e61192e613b289f5d2fe21df066017e39c222"
    sha256 cellar: :any,                 arm64_sonoma:  "7ed02e40fcba5539bf8dca7fdd7d019e6123fc303a6efdccc20b0fe5b4c0efdd"
    sha256 cellar: :any,                 arm64_ventura: "56b258878929b266f390fe480c5eb86764bd0b717c47207620469104eb80fc3b"
    sha256 cellar: :any,                 sonoma:        "79ff76f8447c307e3864838efac9044ade965d9a1b1f087f6a4625c4ca35f453"
    sha256 cellar: :any,                 ventura:       "4871eb27ac99e62914955201e9e32814f1f517337478fbd9f78c8e4abcc188f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7097e178d85565adb0f63f81312d831b097fc089a1dcee0e9d985e938138d4e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d23a39813f52cd191b33533b002c50c07f89f9236792d4730fc7647506d0773"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "libtorrent-rakshasa"
  depends_on "xmlrpc-c"

  uses_from_macos "curl"
  uses_from_macos "ncurses"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--with-xmlrpc-c", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    pid = spawn bin/"rtorrent", "-n", "-s", testpath
    sleep 10
    assert_path_exists testpath/"rtorrent.lock"
  ensure
    Process.kill("HUP", pid)
  end
end
