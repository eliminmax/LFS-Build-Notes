# tmux 3.3a

A **t**erminal **mul**tiplexer with an uncreative name.

## Dependencies

* libevent (BLFS libevent)

## Installation

```sh
wget https://github.com/tmux/tmux/releases/download/3.3a/tmux-3.3a.tar.gz
tar xf tmux-3.3a.tar.gz
cd tmux-3.3a
./configure --prefix=/usr --sysconfdir=/etc --docdir=/usr/share/doc/tmux-3.3a
make
sudo make install
```
