# Murrine GTK+-2 Theme Engine

A GTK+-2 Theme Engine, used by the Materia GTK theme.

## Dependencies

* GTK+-2 (BLFS GTK+-2)
* intltool ([deps/intltool](./intltool.md))

## Installation

```sh
wget https://download.gnome.org/sources/murrine/0.98/murrine-0.98.2.tar.xz

tar xf murrine-0.98.2.tar.xz
cd murrine-0.98.2

./configure --disable-static --prefix=/usr --sysconfdir=/etc --localstatedir=/var --docdir=/usr/share/doc/murrine-0.98.2
make
sudo make install
```
