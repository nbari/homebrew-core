class Killswitch < Formula
  desc "Create & load a kill-switch pf.conf"
  homepage "https://vpn-kill-switch.com/"
  url "https://github.com/vpn-kill-switch/killswitch.git", :tag => "0.7.1", :revision => "5a2a02aa0bff87a05d6d75a978e7addfcc1beed6"
  head "https://github.com/vpn-kill-switch/killswitch.git"

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-ldflags", "-s -w -X main.version=#{version}", "-o", "#{bin}/killswitch", "cmd/killswitch/main.go"
  end

  test do
    system "#{bin}/killswitch", "-v"
  end
end
