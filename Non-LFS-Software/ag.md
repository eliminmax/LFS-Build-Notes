### the silver searcher (ag)

A tool to rapidly search through a directory tree for regex matches. Much faster than `grep --recursive`. Installed from git repository, commit `a61f178`.

Has 4 dependencies: Automake, pkg-config, liblzma, and PCRE. The first three are part of the base LFS system, and PCRE is part of BLFS, and was already installed for other software that depends on it.

## Dependencies

* PCRE (BLFS PCRE)

## Installation

```sh
git clone https://github.com/ggreer/the_silver_searcher.git the_silver_searcher-a61f178
cd the_silver_searcher-a61f178
git checkout a61f178
./autogen.sh
./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --docdir=/usr/share/doc/the_silver_searcher-a61f178
make
# install stripped version, man pages, and bash completion, but not zsh completion
sudo make install-strip install-man
sudo install -m644 -C -o root -g root ag.bashcomp.sh /usr/share/bash-Completion/completions/ag
```
