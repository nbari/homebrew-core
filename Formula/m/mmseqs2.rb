class Mmseqs2 < Formula
  desc "Software suite for very fast sequence search and clustering"
  homepage "https://mmseqs.com/"
  url "https://github.com/soedinglab/MMseqs2/archive/refs/tags/17-b804f.tar.gz"
  version "17-b804f"
  sha256 "300ebd14bf4e007b339037e5f73d8ff9c4e34f8495204c4a8c59c7672b689db2"
  license "MIT"
  head "https://github.com/soedinglab/MMseqs2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ea1ea5c08498f6ad51699f1893a8e23e0baeed53db5939bafd0a746ef398f63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27680634e7c71319cff9d0858fc4f09866983e79fbab178f9f0f1039c8c7fae8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "abf9aebc0cef534728bf7f1632a3ab6f5fccdbbc3f65134795cdd77da6990f72"
    sha256 cellar: :any_skip_relocation, sonoma:        "634ea04176f89d6a6c149c6ede52ba9ff1f9c12f7cecd9a8008a613956b48871"
    sha256 cellar: :any_skip_relocation, ventura:       "275e82914a9a19dc429541ce8acc36007ff7c60b77c266c6c4e9c29cf8ff5762"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f06909bd45000c0646b4b4318298f455063c4f63ae51c43ed775c55790770d0f"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "wget"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "gawk"
  end

  # `git ls-remote https://github.com/soedinglab/MMseqs2.wiki.git HEAD`
  resource "documentation" do
    url "https://github.com/soedinglab/MMseqs2.wiki.git",
        revision: "b1ccffcaf6be0f857e37670a260311f2416b6794"
  end

  def install
    args = %W[
      -DHAVE_TESTS=0
      -DHAVE_MPI=0
      -DVERSION_OVERRIDE=#{version}
    ]

    args << if Hardware::CPU.arm?
      "-DHAVE_ARM8=1"
    else
      "-DHAVE_SSE4_1=1"
    end

    if OS.mac?
      libomp = Formula["libomp"]
      args << "-DOpenMP_C_FLAGS=-Xpreprocessor -fopenmp -I#{libomp.opt_include}"
      args << "-DOpenMP_C_LIB_NAMES=omp"
      args << "-DOpenMP_CXX_FLAGS=-Xpreprocessor -fopenmp -I#{libomp.opt_include}"
      args << "-DOpenMP_CXX_LIB_NAMES=omp"
      args << "-DOpenMP_omp_LIBRARY=#{libomp.opt_lib}/libomp.a"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    resource("documentation").stage { doc.install Dir["*"] }
    pkgshare.install "examples"
    bash_completion.install "util/bash-completion.sh" => "mmseqs.sh"
  end

  def caveats
    on_intel do
      "MMseqs2 requires at least SSE4.1 CPU instruction support." unless Hardware::CPU.sse4?
    end
  end

  test do
    resource "homebrew-testdata" do
      url "https://github.com/soedinglab/MMseqs2/releases/download/12-113e3/MMseqs2-Regression-Minimal.zip"
      sha256 "ab0c2953d1c27736c22a57a1ccbb976c1320435fad82b5c579dbd716b7bae4ce"
    end

    resource("homebrew-testdata").stage do
      system "./run_regression.sh", "#{bin}/mmseqs", "scratch"
    end
  end
end
