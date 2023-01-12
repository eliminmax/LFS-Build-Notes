# xclip

Command-line interface to the X11 clipboard system.

## Dependencies

* libXt (BLFS Xorg Libraries)
* libXmu (BLFS Xorg Libraries)
* libX11 (BLFS Xorg Libraries)

## Installation

```sh
wget https://github.com/astrand/xclip/archive/refs/tags/0.13.tar.gz -O xclip-0.13.tar.gz
wget https://raw.githubusercontent.com/eliminmax/LFS-Build-Notes/main/Non-LFS-Software/patches/xclip-0.13_eliminmax-unified-patch-1.patch

tar xf xclip-0.13.tar.gz
cd xclip-0.13

patch -Np1 -i ../xclip-0.13_eliminmax-unified-patch-1.patch

autoreconf
autoupdate

./configure $XORG_CONFIG

make
sudo make prefix=/usr install
```
