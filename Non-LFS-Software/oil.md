# Oil

The Oil shell is "our upgrade path to bash". It consists of `osh`, a largely bash-compatible shell, and `oil`, a new shell language that aims to correct many of the pitfalls of Bourne-style shells. They share a lot of overlapping code. They are written in an interesting way - they're implemented in a subset of Python 2, which is then transpiled into C++ to distribute as release tarballs.

I generated the release tarball for this myself on my primary system. It's based on oil-0.12.9, with some changes to the way history is stored. I considered rebuilding it on the LFS system, but I'd rather not install Python 2 on it.

The build dependencies are all satisfied as part of a base LFS system.

## Installation

```sh
wget https://dl.earrayminkoff.tech/oil-0.12.9-hist.tar.gz

tar xf oil-0.12.9-hist.tar.gz
cd oil-0.12.9-hist

./configure --prefix=/usr --datarootdir=/usr/share --with-readline
make
sudo ./install
```
