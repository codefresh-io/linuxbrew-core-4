class Hidapi < Formula
  desc "Library for communicating with USB and Bluetooth HID devices"
  homepage "https://github.com/libusb/hidapi"
  url "https://github.com/libusb/hidapi/archive/hidapi-0.11.0.tar.gz"
  sha256 "391d8e52f2d6a5cf76e2b0c079cfefe25497ba1d4659131297081fc0cd744632"
  license :cannot_represent
  head "https://github.com/libusb/hidapi.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "785868d1b729ada62b76b49e1d1340a347b88db0c9a69a12d3417bd5539e750d"
    sha256 cellar: :any,                 big_sur:       "33612c008465ce62b39f1aeb519eaa58bd1d8e1296b118894765d4729b505f2b"
    sha256 cellar: :any,                 catalina:      "a90ba3cd69ce428830a5dfba205cf375fd962b19b5653a702b7c1d8616fa62d0"
    sha256 cellar: :any,                 mojave:        "35827213bd2b8b87c8574d7cf5f4fd18795dbf267d0b9355b4d0e528f9894b4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c1381768f1dc088e5290799d8e08135c7d864e22c01a80721d706b671bcdc57" # linuxbrew-core
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  on_linux do
    depends_on "libusb"
    depends_on "systemd" # for libudev
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DHIDAPI_BUILD_HIDTEST=ON"
      system "make", "install"

      # hidtest/.libs/hidtest does not exist for Linux, install it for macOS only
      bin.install "hidtest/hidtest" if OS.mac?
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "hidapi.h"
      int main(void)
      {
        return hid_exit();
      }
    EOS

    flags = ["-I#{include}/hidapi", "-L#{lib}"]
    on_macos do
      flags << "-lhidapi"
    end
    on_linux do
      flags << "-lhidapi-hidraw"
    end
    flags += ENV.cflags.to_s.split
    system ENV.cc, "-o", "test", "test.c", *flags
    system "./test"
  end
end
