class ProtocGenGogo < Formula
  desc "Protocol Buffers for Go with Gadgets"
  homepage "https://github.com/gogo/protobuf"
  url "https://github.com/gogo/protobuf/archive/v1.3.2.tar.gz"
  sha256 "2bb4b13d6e56b3911f09b8e9ddd15708477fbff8823c057cc79dd99c9a452b34"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/gogo/protobuf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9ba5d8b674ef61368f7dfdc0f072190ec0927fc3c42fa846535ccd2dfd3030f9"
    sha256 cellar: :any_skip_relocation, big_sur:       "fd8a46c27fe74626f154ec7ea64183b1dfcfaea1cba6f35ebd91da51383c4122"
    sha256 cellar: :any_skip_relocation, catalina:      "fd8a46c27fe74626f154ec7ea64183b1dfcfaea1cba6f35ebd91da51383c4122"
    sha256 cellar: :any_skip_relocation, mojave:        "fd8a46c27fe74626f154ec7ea64183b1dfcfaea1cba6f35ebd91da51383c4122"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18bdf123e5ec56290a6401dab5a7907c4d10b0972242c099ff24881d66f27d30" # linuxbrew-core
  end

  depends_on "go" => :build
  depends_on "protobuf"

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./protoc-gen-gogo"
  end

  test do
    protofile = testpath/"proto3.proto"
    protofile.write <<~EOS
      syntax = "proto3";
      package proto3;
      message Request {
        string name = 1;
        repeated int64 key = 2;
      }
    EOS
    system "protoc", "--gogo_out=.", "proto3.proto"
    assert_predicate testpath/"proto3.pb.go", :exist?
    refute_predicate (testpath/"proto3.pb.go").size, :zero?
  end
end
