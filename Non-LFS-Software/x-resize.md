# x-resize

A simple shell script which, when set up with a udev rule and proper drivers, can automatically resize the screen to fit the size of the window on the host system.
Based on [this Github Gist](https://gist.github.com/3lpsy/4cc344ae031bf77595991c536cbd3275), with paths modified to be better integrated into the LFS environment, and the ability to respond to events involving cards other than `/dev/dri/card0` - specifically, it matches `card?`, where `?` is any single character.

Depends on udev (part of systemd) and Xorg with the xf86-video-qxl driver.

## Dependencies

* Xorg Server (BLFS Xorg Server)
* xf86-video-qxl driver ([xf86-video-qxl](./xf86-video-qxl))
* spice-vdagent ([deps/spice-vdagent](./deps/spice-vdagent.md))
* qemu-guest-agent ([deps/qemu-guest-agent](./deps/qemu-guest-agent.md))

## Installation

```sh
wget https://gist.githubusercontent.com/eliminmax/f2eff01a304607b4249cbc4f027cbd91/raw/43296df8c17aa45c1f9772746e911be66a99feb7/x-resize-LFS -O x-resize
sudo install -m744 x-resize /usr/sbin
sudo dd of=/usr/lib/udev/rules.d/50-x-resize.rules <<EOF
ACTION=="change",KERNEL=="card?", SUBSYSTEM=="drm", RUN+="/usr/sbin/x-resize"
EOF
sudo udevadm control --reload-rules
```

