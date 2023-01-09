# spice-protocol

**SPICE**, or the **Simple Protocol for Independent Computing Environments**, is a protocol for accessing other computers' desktops, much like RDP or VNC. Unlike RDP and VNC, it is designed primarily for accessing virtual machines.

This package contains the definition for the protocol, and is required to build the SPICE server

### Package Information

Download (HTTP): https://gitlab.freedesktop.org/spice/spice-protocol/-/archive/v0.14.4/spice-protocol-v0.14.4.tar.bz2

## Installation of spice-protocol

```sh
wget https://gitlab.freedesktop.org/spice/spice-protocol/-/archive/v0.14.4/spice-protocol-v0.14.4.tar.bz2

tar xf spice-protocol-v0.14.4.tar.bz2
cd spice-protocol-v0.14.4

mkdir build
cd build
meson -Dlibdir=/usr/lib -Dbackend=ninja --prefix=/usr --buildtype=release ..
ninja
sudo ninja install
```
