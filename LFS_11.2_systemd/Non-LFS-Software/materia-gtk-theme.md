# Materia Compact GTK Theme

A clean, no-nonsense GTK 2, 3, and 4 theme that follows the principles of material design. Comes in standard and compact versions, and 3 color variations. I like to use the compact dark version almost exclusively, but I'd like to keep another option open, so I'm building it with the default color scheme as well.

## Dependencies

* sassc (BLFS sassc)
* gnome-themes-extra (BLFS gnome-themes-extra)
* murrine ([deps/murrine](./deps/murrine.md)

## Installation

```sh
wget https://github.com/nana-4/materia-theme/archive/refs/tags/v20210322.tar.gz -O materia-theme-20210322.tar.gz

tar xf materia-theme-20210322.tar.gz
cd materia-theme-20210322
mkdir build
cd build
meson --prefix=/usr -Dsizes=compact -Dcolors=default,dark -Dlibdir=/usr/lib -Dbackend=ninja -Dstrip=true -Ddebug=false ..
ninja
sudo ninja install
```

