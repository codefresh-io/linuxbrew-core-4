class Gtkx < Formula
  desc "GUI toolkit"
  homepage "https://gtk.org/"
  license "LGPL-2.0-or-later"

  stable do
    url "https://download.gnome.org/sources/gtk+/2.24/gtk+-2.24.33.tar.xz"
    sha256 "ac2ac757f5942d318a311a54b0c80b5ef295f299c2a73c632f6bfb1ff49cc6da"
  end

  livecheck do
    url :stable
    regex(/gtk\+[._-]v?(2\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "b304a9f2d24f97e179cb5731713fc4876a730b507eb057bba4f9097af46d7708"
    sha256 big_sur:       "8ead5b96878ad431ac3e23dc3bd20bb4eac509c63c231e594986a0fa331e157f"
    sha256 catalina:      "3900f64476d7988670b5d0c855f072fba0af2b1bb323acf4f126f70c95a38616"
    sha256 mojave:        "10d1f2a81a115b9cf1e8c76fbd6cdc58f5b4593eb7f9e15cbe0127e14221dd06"
    sha256 x86_64_linux:  "7a6506474b1d9921a0dd5b548d6efc3ae58f2f40c283eb3c023af6adbe156a0b" # linuxbrew-core
  end

  head do
    url "https://gitlab.gnome.org/GNOME/gtk.git", branch: "gtk-2-24"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "atk"
  depends_on "gdk-pixbuf"
  depends_on "hicolor-icon-theme"
  depends_on "pango"

  on_linux do
    depends_on "cairo"
    depends_on "libxinerama"
    depends_on "libxcomposite"
    depends_on "libxcursor"
    depends_on "libxdamage"
    depends_on "libxfixes"
    depends_on "libxrandr"
  end

  # Patch to allow Eiffel Studio to run in Cocoa / non-X11 mode, as well as Freeciv's freeciv-gtk2 client
  # See:
  # - https://gitlab.gnome.org/GNOME/gtk/-/issues/580
  # referenced from
  # - https://bugzilla.gnome.org/show_bug.cgi?id=757187
  # referenced from
  # - https://bugzilla.gnome.org/show_bug.cgi?id=557780
  # - Homebrew/homebrew-games#278
  patch do
    url "https://gitlab.gnome.org/GNOME/gtk/uploads/2a194d81de8e8346a81816870264b3bf/gdkimage.patch"
    sha256 "ce5adf1a019ac7ed2a999efb65cfadeae50f5de8663638c7f765f8764aa7d931"
  end

  def backend
    backend = "quartz"
    on_linux do
      backend = "x11"
    end
    backend
  end

  def install
    args = ["--disable-dependency-tracking",
            "--disable-silent-rules",
            "--prefix=#{prefix}",
            "--enable-static",
            "--disable-glibtest",
            "--enable-introspection=yes",
            "--with-gdktarget=#{backend}",
            "--disable-visibility"]

    if build.head?
      inreplace "autogen.sh", "libtoolize", "glibtoolize"
      ENV["NOCONFIGURE"] = "yes"
      system "./autogen.sh"
    end
    system "./configure", *args
    system "make", "install"

    inreplace bin/"gtk-builder-convert", %r{^#!/usr/bin/env python$}, "#!/usr/bin/python"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gtk/gtk.h>

      int main(int argc, char *argv[]) {
        GtkWidget *label = gtk_label_new("Hello World!");
        return 0;
      }
    EOS
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    harfbuzz = Formula["harfbuzz"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/gtk-2.0
      -I#{libpng.opt_include}/libpng16
      -I#{lib}/gtk-2.0/include
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lgdk-#{backend}-2.0
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lgtk-#{backend}-2.0
      -lpango-1.0
      -lpangocairo-1.0
    ]
    on_macos do
      flags << "-lintl"
    end
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
