class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://github.com/rakshasa/libtorrent/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "ca3b96bc478db2cd282ccb87b91b169662d7c9298dbca9934f8556c2935cab73"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f0033f94918a83866aab21e91fc5ed37ffc5243ea77b3fc0c61ae05f207d8e51"
    sha256 cellar: :any,                 arm64_sonoma:  "d68d0da1378dbe738a9b79fc5e223c92b2129309fe782c6132dcf6fa7923cadd"
    sha256 cellar: :any,                 arm64_ventura: "1471eddbefdc36dda2d00e9bec1182c8839956993a65ce144b9988ecbbd25b00"
    sha256 cellar: :any,                 sonoma:        "9e20591298a4cf9504fe0782633158724533e387568101ca2bf9b10b1dd07a15"
    sha256 cellar: :any,                 ventura:       "857ae17e362a81dcb396bee9cc601218bf042ad859c88f76220fafb5fe41afff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9652ccd33b1dd4a625cc43cf45caee82cec36bd5eeb0a6689e1a4788b568233"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdae3190fd06828b875b85bb2cf6a9c4efc15bf07947c061cb498e6edd436789"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  conflicts_with "libtorrent-rasterbar", because: "both use the same libname"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>#{"  "}
      #include <torrent/torrent.h>
      int main(void)
      {
        std::cout << torrent::version() << std::endl;
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", "-L#{lib}", "-ltorrent"
    assert_match version.to_s, shell_output("./test").strip
  end
end
