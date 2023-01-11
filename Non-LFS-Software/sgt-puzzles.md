## Simon Tatham's Portable Puzzle Collection

A selection of simple puzzle games, maintained by the developer of the PuTTY terminal/SSH client for windows. Can be compiled to Java, Javascript+WebAssembly, or native programs on Windows, macOS, and/or Linux systems.

## Dependencies

* GTK+-2 (BLFS GTK+-2) or GTK+-3 (BLFS GTK+-3)

## Installation

```sh
## Git server is slow, so only download changes since the beginning of 2023, to save on download time
git clone --shallow-since=@1672531200 https://git.tartarus.org/simon/puzzles.git sgt-puzzles-e66d027
cd sgt-puzzls-e66d027
git checkout e66d027
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=/usr/lib -DCMAKE_INSTALL_LOCALEDIR=/usr/share/locale -DCMAKE_INSTALL_MANDIR=/usr/share/man .
make
sudo make install
```
