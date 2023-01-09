# QEMU Guest Agent

Allows for host-to-guest communication on QEMU VMs.

## Dependencies

* GLib (BLFS GLib)
* alsa-lib (BLFS alsa-lib)
* pcre2 (BLFS PCRE2)


## Installation

```sh
wget https://download.qemu.org/qemu-7.0.0.tar.xz

tar xf qemu-7.0.0.tar.xz
cd qemu-7.0.0
./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --libdir=/usr/lib --docdir=/usr/share/doc/"$(basename "$PWD")" --without-default-features --enable-guest-agent --without-default-devices
make qemu-ga
sudo strip build/qga/qemu-ga -o /usr/sbin/qemu-ga

sudo dd of=/usr/lib/systemd/system/qemu-guest-agent.service <<EOF
[Unit]
Description=QEMU Guest Agent
BindsTo=dev-virtio\x2dports-org.qemu.guest_agent.0.device
After=dev-virtio\x2dports-org.qemu.guest_agent.0.device

[Service]
ExecStart=-/usr/sbin/qemu-ga
Restart=always
RestartSec=0

[Install]
EOF

sudo dd of=/usr/lib/udev/rules.d/60-qemu-guest-agent.rules <<EOF
SUBSYSTEM=="virtio-ports", ATTR{name}=="org.qemu.guest_agent.0",  TAG+="systemd" ENV{SYSTEMD_WANTS}="qemu-guest-agent.service"
EOF
```

After that, reboot the system.
