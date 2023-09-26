# byobu

A "terminal window manager" that I like to use for multitasking. Uses either GNU `screen` or `tmux` as a back-end. The `byobu-config` script has runtime dependency on snack, a part of the newt package.

## Dependencies

* tmux ([deps/tmux](./deps/tmux.md))
* snack (BLFS newt)

## Installation

```sh
wget https://launchpad.net/byobu/trunk/5.133/+download/byobu_5.133.orig.tar.gz

tar xf byobu_5.133.orig.tar.gz
cd byobu_5.133

./configure --prefix=/usr --sysconfdir=/etc --docdir=/usr/share/doc/byobu-5.133 --localstatedir=/var
make
sudo make install
```
