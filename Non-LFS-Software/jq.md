# jq

jq is a tool to parse JSON data.

## Dependencies

* Onigmura ([deps/oniguruma](./deps/onigmura.md))

## Installation

```sh
wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-1.6.tar.gz
tar xf jq-1.6.tar.gz
cd jq-1.6
./configure --disable-static --prefix=/usr --libdir=/usr/lib --localstatedir=/var --docdir=/usr/share/doc/jq-1.6 --sysconfdir=/etc
make
sudo make install-strip
# Installing copies AUTHORS, COPYING, READNE, and README.md to this unwanted directory, so I delete it.
sudo rm -rf /usr/share/doc/jq
```
