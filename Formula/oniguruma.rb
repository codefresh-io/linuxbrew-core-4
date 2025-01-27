class Oniguruma < Formula
  desc "Regular expressions library"
  homepage "https://github.com/kkos/oniguruma/"
  url "https://github.com/kkos/oniguruma/releases/download/v6.9.7.1/onig-6.9.7.1.tar.gz"
  sha256 "6444204b9c34e6eb6c0b23021ce89a0370dad2b2f5c00cd44c342753e0b204d9"
  license "BSD-2-Clause"
  head "https://github.com/kkos/oniguruma.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:[._-](?:mark|rev)\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "ba81edc5b1d7b345bd219cd41e526bd3cfea09d793d4bfba7737da138a307387"
    sha256 cellar: :any,                 big_sur:       "8154799c44b09d3283fab1d9e5c2a59c8026f8bf6358f94f99343cb0a9d84847"
    sha256 cellar: :any,                 catalina:      "fcb2b0c651e23b91ca63bf821b84bb1fb41d05dfcfdb601542228d0803db6384"
    sha256 cellar: :any,                 mojave:        "a09a31d8e1cf76b4c6025a4578259bb0b82a6b56733155afb2f363cc1ae5adbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a70a49d184cdf6c2212e7c64bd5198c5b885182f6b0bd03641f4f2c737887df" # linuxbrew-core
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-vfi"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match(/#{prefix}/, shell_output("#{bin}/onig-config --prefix"))
  end
end
