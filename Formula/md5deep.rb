class Md5deep < Formula
  desc "Recursively compute digests on files/directories"
  homepage "https://github.com/jessek/hashdeep"
  url "https://github.com/jessek/hashdeep/archive/release-4.4.tar.gz"
  sha256 "dbda8ab42a9c788d4566adcae980d022d8c3d52ee732f1cbfa126c551c8fcc46"
  license "GPL-2.0"
  revision 1
  head "https://github.com/jessek/hashdeep.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5d910e7454fa350663a1955628c254b7acf813dd7b3aaec162a7be2c002197f0"
    sha256 cellar: :any_skip_relocation, big_sur:       "d53f71333428c98de807b2ed6be18fcfd62d473d9994e19db7c7a8db390cac95"
    sha256 cellar: :any_skip_relocation, catalina:      "3156ba425284d497cdc5377c1d5d7659fe741811c5b1a390a2dd45f98bf0a19a"
    sha256 cellar: :any_skip_relocation, mojave:        "c9e915e46aec5d2ec5460d6b8d73cd7f21b615b8882ab7eef3bbea6c25a8821e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a2b54c3e31489a4c89e5d4fe1b49351722918efe99b0d361f8b39a97c345b12" # linuxbrew-core
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  # Fix compilation error due to very old GNU config scripts in source repo
  # reported upstream at https://github.com/jessek/hashdeep/issues/400
  patch :DATA if Hardware::CPU.arm?

  # Fix compilation error due to pointer comparison
  if MacOS.version >= :sierra
    patch do
      url "https://github.com/jessek/hashdeep/commit/8776134.patch?full_index=1"
      sha256 "3d4e3114aee5505d1336158b76652587fd6f76e1d3af784912277a1f93518c64"
    end
  end

  def install
    system "sh", "bootstrap.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"testfile.txt").write("This is a test file")
    # Do not reduce the spacing of the below text.
    assert_equal "91b7b0b1e27bfbf7bc646946f35fa972c47c2d32  testfile.txt",
    shell_output("#{bin}/sha1deep -b testfile.txt").strip
  end
end

__END__
diff --git a/config.guess b/config.guess
index cc726cd..37d7e9d 100755
--- a/config.guess
+++ b/config.guess
@@ -1130,6 +1130,9 @@ EOF
     *:Rhapsody:*:*)
 	echo ${UNAME_MACHINE}-apple-rhapsody${UNAME_RELEASE}
 	exit 0 ;;
+	arm64:Darwin:*:*)
+	echo arm-apple-darwin"$UNAME_RELEASE"
+	exit ;;
     *:Darwin:*:*)
 	case `uname -p` in
 	    *86) UNAME_PROCESSOR=i686 ;;