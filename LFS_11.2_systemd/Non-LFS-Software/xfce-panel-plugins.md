# Xfce4 panel plugins

Xfce4's panels have various items available that are not included in the xfce4-panel source tree. These are the ones I built.

## Whisker Menu

A plugin for Xfce4 that adds a more advanced app menu

### Dependencies

* gtk-3 (BLFS GTK+-3)
* exo (BLFS Exo)
* garcon (BLFS Garcon)
* libxfce4panel (BLFS xfce4-panel)
* libxfce4ui (BLFS libxfce4ui)
* libxfce4util (BLFS libxfce4util)
* accountsservice (BLFS AccountsService)

### Installation

```sh
wget https://archive.xfce.org/src/panel-plugins/xfce4-whiskermenu-plugin/2.7/xfce4-whiskermenu-plugin-2.7.1.tar.bz2

tar xf xfce4-whiskermenu-plugin.2.7.1.tar.bz2
cd xfce4-whiskermenu-plugin.2.7.1

mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=/usr/lib -DCMAKE_INSTALL_LOCALEDIR=/usr/share/locale -DCMAKE_INSTALL_MANDIR=/usr/share/man ..
make
sudo make install
```

## Docklike

An alternative to Xfce4's window buttons that is more similar to a traditional dock.

### Dependencies

* libxfce4panel (BLFS xfce4-panel)
* libxfce4ui (BLFS libxfce4ui)
* gtk-3 (BLFS GTK+-3)
* cairo (BLFS Cairo)
* libwnck-3 (BLFS libwnck-40)
* x11 (BLFS Xorg Libraries)
* exo-utils (BLFS Exo)

```sh
wget https://archive.xfce.org/src/panel-plugins/xfce4-docklike-plugin/0.4/xfce4-docklike-plugin-0.4.0.tar.bz2

tar xf xfce4-docklike-plugin-0.4.0.tar.bz2
cd xfce4-docklike-plugin-0.4.0

./configure --prefix=/usr --libdir=/usr/lib --disable-static --docdir=/usr/share/doc/xfce4-docklike-plugin-0.4.0 --localedir=/usr/share/locale --mandir=/usr/share/man
make
sudo make install
```
