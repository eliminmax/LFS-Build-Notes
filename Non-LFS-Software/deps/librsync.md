# librsync-2.3.2

From the README:

> librsync is a library for calculating and applying network deltas, with an interface designed to ease integration into diverse network applications.
>
> librsync encapsulates the core algorithms of the rsync protocol, which help with efficient calculation of the differences between two files. The rsync algorithm is different from most differencing algorithms because it does not require the presence of the two files to calculate the delta. Instead, it requires a set of checksums of each block of one file, which together form a signature for that file. Blocks at any position in the other file which have the same checksum are likely to be identical, and whatever remains is the difference.
>
> This algorithm transfers the differences between two files without needing both files on the same system.
>
> librsync is for building other programs that transfer files as efficiently as rsync. You can use librsync in a program you write to do backups, distribute binary patches to programs, or sync directories to a server or between peers.

Librsync depends on popt, which is included in BLFS (though I did not realize that when I first built it.)


Build/installation instructions:

```sh
wget https://github.com/librsync/librsync/releases/download/v2.3.2/librsync-2.3.2.tar.gz
tar xf librsync-2.3.2.tar.gz
cd librsync-2.3.2
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=/usr/lib -DCMAKE_INSTALL_LOCALEDIR=/usr/share/locale -DCMAKE_INSTALL_MANDIR=/usr/share/man .
make
sudo make install
```
