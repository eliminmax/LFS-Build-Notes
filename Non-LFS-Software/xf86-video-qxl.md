# xf86-video-qxl

A driver for Xorg that takes advantage of Red Hat's QXL paravirtual graphic card to get near-native rendering performance within a QEMU/KVM virtual machine.

## Dependencies

* Xorg Server (BLFS Xorg Server)

## Installation

```sh
git clone https://gitlab.freedesktop.org/xorg/driver/xf86-video-qxl.git
cd xf86-video-qxl
git remote add jmbreuer https://gitlab.freedesktop.org/jmbreuer/xf86-video-qxl.git
git fetch jmbreuer
git merge jmbreuer/fix-xorg-server-21
./autogen.sh
./configure $XORG_CONFIG
make
sudo make install
```
