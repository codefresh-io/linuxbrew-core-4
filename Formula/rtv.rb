class Rtv < Formula
  include Language::Python::Virtualenv

  desc "Command-line Reddit client"
  homepage "https://github.com/michael-lazar/rtv"
  url "https://github.com/michael-lazar/rtv/archive/v1.27.0.tar.gz"
  sha256 "c57a6cbb2525160b6aaa9180aec0293962b6969675f8ac0f2cfacff3cbd00d7c"
  license "MIT"
  revision 5
  head "https://github.com/michael-lazar/rtv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "aa894b5babc332d7d0f0e06e7a82afb6053514515186fe2b35b1c604d545b6e2"
    sha256 cellar: :any_skip_relocation, big_sur:       "0abf2060366a1e64f0d385649ff8a3ad0f57acec0b07d45bda57456c63a7b91f"
    sha256 cellar: :any_skip_relocation, catalina:      "c3a4eb9ce139d6d768a8ff6f3dfaaf6c24dee517fd18a8243ba88215df162650"
    sha256 cellar: :any_skip_relocation, mojave:        "aaffc3c8e0859424697554af41e79b82057e252b1d3ce5eb3e929a0695ed5785"
    sha256 cellar: :any_skip_relocation, high_sierra:   "76dd530c8986d96aa2417f565beb6b2db7662c84de06ff65e4953ceceff761d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06f7013a93251f013cb04c794127df9e731e7605e766c1712a4b3af1a601848c"
  end

  deprecate! date: "2019-06-02", because: :repo_archived

  depends_on "python@3.10"
  depends_on "six"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/a1/69/daeee6d8f22c997e522cdbeb59641c4d31ab120aba0f2c799500f7456b7e/beautifulsoup4-4.10.0.tar.gz"
    sha256 "c23ad23c521d818955a4151a67d81580319d4bf548d3d49f4223ae041ff98891"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6d/78/f8db8d57f520a54f0b8a438319c342c61c22759d8f9a1cd2e2180b5e5ea9/certifi-2021.5.30.tar.gz"
    sha256 "2bbf76fd432960138b3ef6dda3dde0544f27cbf8546c458e60baf371917ba9ee"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/eb/7f/a6c278746ddbd7094b019b08d1b2187101b1f596f35f81dc27f57d8fcf7c/charset-normalizer-2.0.6.tar.gz"
    sha256 "5ec46d183433dcbd0ab716f2d7f29d8dee50505b3fdb40c6b985c7c4f5a3591f"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/92/3c/34f8448b61809968052882b830f7d8d9a8e1c07048f70deb039ae599f73c/decorator-5.1.0.tar.gz"
    sha256 "e59913af105b9860aa2c8d3272d9de5a56a4e608db9a2f167a8480b323d529a7"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cb/38/4c4d00ddfa48abe616d7e572e02a04273603db446975ab46bbcd36552005/idna-3.2.tar.gz"
    sha256 "467fbad99067910785144ce333826c71fb0e63a425657295239737f7ecd125f3"
  end

  resource "kitchen" do
    url "https://files.pythonhosted.org/packages/d9/ca/3365cb1160533be8c8b57dbfd6502f367d35e30935ee89a003c664740714/kitchen-1.2.6.tar.gz"
    sha256 "b84cf582f1bd1556b60ebc7370b9d331eb9247b6b070ce89dfe959cba2c0b03c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e7/01/3569e0b535fb2e4a6c384bdbed00c55b9d78b5084e0fb7f4d0bf523d7670/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/c8/3f/e71d92e90771ac2d69986aa0e81cf0dfda6271e8483698f4847b861dd449/soupsieve-2.2.1.tar.gz"
    sha256 "052774848f448cf19c7e959adf5566904d525f33a3f8b6ba6f6f8f26ec7de0cc"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/rtv", "--version"
  end
end
