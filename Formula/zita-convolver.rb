class ZitaConvolver < Formula
  desc "Fast, partitioned convolution engine library"
  homepage "https://kokkinizita.linuxaudio.org/linuxaudio/"
  url "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/zita-convolver-4.0.3.tar.bz2"
  sha256 "9aa11484fb30b4e6ef00c8a3281eebcfad9221e3937b1beb5fe21b748d89325f"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/index.html"
    regex(/href=.*?zita-convolver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "dd52351558f1a7d5860d8227ee71fb2fa28abf751adb4193dc63c8cb72f076ae"
    sha256 cellar: :any, big_sur:       "0e712ab784293d338e277912151e068c7117f902165e7e4dcdd231ba8b3767fd"
    sha256 cellar: :any, catalina:      "a616c118732c9f2c3775348e598a972abab7ae67b7cb0f283884cddaa55ce93d"
    sha256 cellar: :any, mojave:        "e9bfda6d2d3119f93ea0d570b9b3516d44513c3eafc206543f8fb055707db8fd"
    sha256 cellar: :any, high_sierra:   "b8b3326ead45ef0e126488d9c96a181f15888a11b707278c61c2ceeee312b37d"
    sha256 cellar: :any, x86_64_linux:  "e0b4689d517a824e633441a10057cb061bc608fa33eb5f1c3d02196b9b99d8d1" # linuxbrew-core
  end

  depends_on "fftw"

  def install
    cd "source" do
      inreplace "Makefile", "-Wl,-soname,", "-Wl,-install_name," if OS.mac?
      inreplace "Makefile", "ldconfig", "ln -sf $(ZITA-CONVOLVER_MIN) $(DESTDIR)$(LIBDIR)/$(ZITA-CONVOLVER_MAJ)"
      system "make", "install", "PREFIX=#{prefix}", "SUFFIX="
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <zita-convolver.h>

      int main() {
        return zita_convolver_major_version () != ZITA_CONVOLVER_MAJOR_VERSION;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lzita-convolver", "-o", "test"
    system "./test"
  end
end
