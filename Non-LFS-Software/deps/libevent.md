# libevent

Libevent is a dependency for `tmux`, itself a dependency for `byobu`.
The source archive is available at https://github.com/libevent/libevent/releases/download/release-2.1.12-stable/libevent-2.1.12-stable.tar.gz

## Installation

```sh
wget https://github.com/libevent/libevent/releases/download/release-2.1.12-stable/libevent-2.1.12-stable.tar.gz
tar xf libevent-2.1.12-stable.tar.gz
cd libevent-2.1.12-stable
./configure --prefix=/usr --sysconfdir=/etc --disable-static
make
sudo make install
```

