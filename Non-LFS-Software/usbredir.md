# usbredir-0.13.0

A protocol that allows USB devices to be passed to another machine over a network, or from a host system to a guest virtual machine.

## Dependencies

* libusb (BLFS libusb)
* GLib (BLFS GLib)

## Installation

```sh
wget https://www.spice-space.org/download/usbredir/usbredir-0.13.0.tar.xz
tar xf usbredir-0.13.0.tar.xz
cd usbredir-0.13.0
mkdir build && cd build
meson -Dlibdir=/usr/lib -Dbackend=ninja -Dstrip=true -Ddebug=false --buildtype=release --prefix=/usr ..
ninja
sudo ninja install
```
