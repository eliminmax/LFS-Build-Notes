# python-distutils-extra

Extra functionality that extends Python 3'd distutils.

## Dependencies

* intltool ([deps/intltool](./intltool.md))

## Installation

```sh
wget https://deb.debian.org/debian/pool/main/p/python-distutils-extra/python-distutils-extra_2.47.tar.xz

tar xf python-distutils-extra_2.47.tar.xz
cd python-distutils-extra_2.47

pip3 wheel -w dist --no-build-isolation --no-deps $PWD
sudo pip3 install --no-index --find-links dist --no-cache-dir python-distutils-extra
```
