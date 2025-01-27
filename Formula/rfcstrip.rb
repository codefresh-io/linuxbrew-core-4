class Rfcstrip < Formula
  desc "Strips headers and footers from RFCs and Internet-Drafts"
  homepage "https://trac.tools.ietf.org/tools/rfcstrip/"
  url "https://trac.tools.ietf.org/tools/rfcstrip/rfcstrip-1.03.tgz"
  sha256 "db5cccb14b2dfdb5e0e3b4ac98d5af29d1f2f647787bcd470a866e02173d4e5b"

  livecheck do
    url :homepage
    regex(/href=.*?rfcstrip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "709ceeee5ef29ea4b5d1d63a1969ac5297592e31c3c16a47139716c946c09907" # linuxbrew-core
  end

  resource "rfc1149" do
    url "https://www.ietf.org/rfc/rfc1149.txt"
    sha256 "a8660fa4f47bd5e3db1cd5d5baad983d8b6f3f1e8a1a04b8552f3c2ce8f33c18"
  end

  def install
    bin.install "rfcstrip"
    doc.install %w[about todo]
  end

  test do
    resource("rfc1149").stage do
      stripped = shell_output("#{bin}/rfcstrip rfc1149.txt")
      assert !stripped.match(/\[Page \d+\]/) # RFC page numbering
      assert stripped.exclude?("\f") # form feed a.k.a. Control-L
    end
  end
end
