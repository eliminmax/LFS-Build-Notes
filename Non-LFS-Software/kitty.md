### kitty-0.26.5

An extensible, fast, high-performance GPU-accelerated terminal emulator, with support for python plugins known as "kittens"

Dependencies:

* ImageMagick (BLFS ImageMagick)
* freetype (BLFS FreeType)
* harfbuzz (BLFS HarfBuzz)
* libcanberra (BLFS libcanberra)
* libfontconfig (BLFS Fontconfig)
* libgl1-mesa (BLFS Mesa)
* liblcms2 (BLFS Little CMS 2)
* libpng (BLFS libpng)
* librsync ([deps/librsync](./deps/librsync.md))
* libx11-xcb (BLFS Xorg Libraries)
* libxcursor (BLFS Xorg Libraries)
* libxi (BLFS Xorg Libraries)
* libxkbcommon-x11 (BLFS libxkbcommon)
* libxrandr (BLFS Xorg Libraries)
* pygments (BLFS Python Modules)

I had already installed all of the B/LFS-provided dependencies except for ImageMagick and Little CMS 2. I built those 2, as well as librsync, without issue.

Kitty has its own way of doing things. To build it, you can run the following, but it installs it to the linux-package directory within the source tree by default, so you need to manually copy the build into the /usr directory.

```sh
wget https://github.com/kovidgoyal/kitty/releases/download/v0.26.5/kitty-0.26.5.tar.xz
tar xf kitty-0.26.5.tar.xz
cd kitty-0.26.5
make linux-package
sudo cp -vR --no-preserve=ownership linux-package/* /usr
```
