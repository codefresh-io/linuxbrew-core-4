class Jo < Formula
  desc "JSON output from a shell"
  homepage "https://github.com/jpmens/jo"
  url "https://github.com/jpmens/jo/releases/download/1.4/jo-1.4.tar.gz"
  sha256 "24c64d2eb863900947f58f32b502c95fec8f086105fd31151b91f54b7b5256a2"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ef0996d00e1c8859a597d160af04803aeb7eacc2b8f417f0494979bb9e3de753"
    sha256 cellar: :any_skip_relocation, big_sur:       "e7e0509c877e132429eb5cd71b4150c3ea573c9604e92b4bb31c2de4508eb182"
    sha256 cellar: :any_skip_relocation, catalina:      "15bee62d31331c60c1768949ca11916d242fbe96aafcdc7a66a8359c0f4a9c3c"
    sha256 cellar: :any_skip_relocation, mojave:        "6741c18bb9a9519e325ac4b30989cdd0c735107ee34772097d3d8fde103880eb"
    sha256 cellar: :any_skip_relocation, high_sierra:   "bd19a24ded348995844cf428f74729dc91b3c23a9f144ca1b117108c3d3b5401"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efb6f744ab86f52296366dad2711821bcf942b276ed57ca762bd8ff22c70f1eb" # linuxbrew-core
  end

  head do
    url "https://github.com/jpmens/jo.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "autoreconf", "-i" if build.head?

    system "./configure", "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal %Q({"success":true,"result":"pass"}\n), pipe_output("#{bin}/jo success=true result=pass")
  end
end
