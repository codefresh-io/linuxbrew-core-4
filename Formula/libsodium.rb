class Libsodium < Formula
  desc "NaCl networking and cryptography library"
  homepage "https://libsodium.org/"
  url "https://download.libsodium.org/libsodium/releases/libsodium-1.0.18.tar.gz"
  sha256 "6f504490b342a4f8a4c4a02fc9b866cbef8622d5df4e5452b46be121e46636c1"
  license "ISC"
  revision 1

  livecheck do
    url "https://download.libsodium.org/libsodium/releases/"
    regex(/href=.*?libsodium[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "ab7029c599665005a9c9ec9e72c74bf4d543fd7a995d9af9cfe9e6c10de79177"
    sha256 cellar: :any, big_sur:       "5afc5678e30a174c1e46f1e905124f2619e6d9815ac776836090c0bff85631d6"
    sha256 cellar: :any, catalina:      "db372521cd0b1861a5b578bee22426f3a1f4f7cb3c382be1f842da4715dc65bd"
    sha256 cellar: :any, mojave:        "55245bfcf6654b0914d3f7459b99a08c54ef2560587bf583a1c1aff4cfc81f28"
    sha256 cellar: :any, high_sierra:   "fc972755eb60f4221d7b32e58fc0f94e99b913fefefc84c4c76dc4bca1c5c445"
    sha256 cellar: :any, x86_64_linux:  "f7a0d2d788866c83dfe70624ea4e990a1c9a055f89d07ab3556dafb14e1d5931" # linuxbrew-core
  end

  head do
    url "https://github.com/jedisct1/libsodium.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <sodium.h>

      int main()
      {
        assert(sodium_init() != -1);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}",
                   "-lsodium", "-o", "test"
    system "./test"
  end
end
