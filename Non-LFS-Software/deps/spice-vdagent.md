# SPICE VDAgent

Allows communication between a VM and a SPICE client


## Dependencies

* alsa-lib (BLFS alsa-lib)
* libinput (BLFS Xorg Drivers)
* libevdev (BLFS Xorg Drivers)
* spice-protocol ([deps/spice-protocol](./spice-protocol.md))

## Installation

```sh
wget https://www.spice-space.org/download/releases/spice-vdagent-0.22.1.tar.bz2
tar xf spice-vdagent-0.22.1.tar.bz2
cd spice-vdagent-0.22.1
./configure --disable-static --prefix=/usr --sysconfdir=/etc --localstatedir=/var --docdir=/usr/share/doc/spice-vdagent-0.22.1 --with-init-script=systemd
make
sudo make install
```
