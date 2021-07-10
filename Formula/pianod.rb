class Pianod < Formula
  desc "Pandora client with multiple control interfaces"
  homepage "https://deviousfish.com/pianod/"
  url "https://deviousfish.com/Downloads/pianod2/Devel/pianod2-301.tar.gz"
  sha256 "d6fa01d786af65fe3b4e6f4f97fa048db6619b9443e23f655d3ea8ab4766caee"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_big_sur: "75ead4e63a967f75b1348d5f3edc024fb18b64298546ca6574aeba99c043237c"
    sha256 big_sur:       "cf3e7d096f97341e9a24e30d9763869cfc5b94048aa918e117c7caa87ce2d16e"
    sha256 catalina:      "891923360d9e05cc168e08373c41855f4700d84f9549ce6d86de2f7176a96992"
    sha256 mojave:        "8d1b17ccc15dc42000b73a5f054791f3ec98c48b47df731f5343e35199406ea9"
    sha256 high_sierra:   "37348131ed49c0cb261bb85f41b710fc791ca6aa423534063c3acb23596bfa27"
    sha256 x86_64_linux:  "aec3fc84e9e8d36ac0bc46f1d065a54f654b80bd19ef78c589a7c4d65d4c3baa" # linuxbrew-core
  end

  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libao"
  depends_on "libgcrypt"

  on_linux do
    # pianod uses avfoundation on macOS, ffmpeg on Linux
    depends_on "ffmpeg"
    depends_on "gnutls"
    depends_on "libbsd"
  end

  def install
    ENV["OBJCXXFLAGS"] = "-std=c++11"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/pianod", "-v"
  end
end
