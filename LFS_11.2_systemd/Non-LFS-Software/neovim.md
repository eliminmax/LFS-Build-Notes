# Neovim

By default, Neovim's makefile downloads 3rd-party dependencies and statically links them. I originally was planning on dynamically linking all of them, but that proved to be a bit too painful. I'm never going to use them for anything other than neovim, so there's not much reason to try to force it. The only ones I'm going to configure it to dynamically link against are libuv, which is included in BLFS, and gettext, which is part of LFS.

## Dependencies

* libuv (BLFS libuv)

## Installation

```sh
wget https://github.com/neovim/neovim/archive/refs/tags/v0.8.2.tar.gz -O neovim-0.8.2.tar.gz
tar xf neovim-0.8.2.tar.gz
cd neovim-0.8.2
mkdir .deps
pushd .deps
cmake ../cmake.deps -DCMAKE_GENERATOR=Ninja -DUSE_BUNDLED_LIBUV=OFF -DUSE_BUNDLED_GETTEXT=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr
ninja
popd
mkdir build
cd build
cmake -DCMAKE_GENERATOR=Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=/usr/lib -DCMAKE_INSTALL_LOCALEDIR=/usr/share/locale -DCMAKE_INSTALL_MANDIR=/usr/share/man ..
ninja
sudo ninja install/strip
```

## Replace vim with neovim

First, uninstall vim. To do this, re-extract the source, and re-run the same `./configure` command that it was installed with, then run `make uninstall` as root.

Because I `gunzip`ped then `xz`ed the vim source tarball, and I installed vim with the BLFS instructions, that would look like the following:
```sh
cd /sources/active

tar xf ../vim-9.0.0228.tar.xz
cd vim-9.0.0228

echo '#define SYS_VIMRC_FILE  "/etc/vimrc"' >>  src/feature.h &&
echo '#define SYS_GVIMRC_FILE "/etc/gvimrc"' >> src/feature.h &&

./configure --prefix=/usr        \
            --with-features=huge \
            --enable-gui=gtk3    \
            --with-tlib=ncursesw

sudo make uninstall
```

Then, you can either add `vi` and `vim` as symlinks pointing to `nvim` in `/usr/bin`, or, if you find any of the `ex`, `view`, and `vimdiff` commands helpful, you can create a wrapper script that re-creates them by doing the following:

```sh
cd /sources/active

sudo install -dm755 /usr/libexec/neovim

cat > nvim.wrapper <<EOF
#!/bin/sh
case "\$0" in
    */ex) exec nvim -e "\$@" ;;
    */view) exec nvim -R "\$@" ;;
    */vimdiff) exec nvim -d "\$@" ;;
    *) exec nvim "\$@" ;;
esac
EOF

sudo install -m755 nvim.wrapper /usr/libexec/neovim

cd /usr/bin

for i in ex vi vim view vimdiff; do
    sudo ln -vs /usr/libexec/neovim/nvim.wrapper "$i"
done
```

### xxd

If, like me, you still want `xxd` available, you can re-install it.

Assuming you've extracted the vim source tarball to `/sources/active/`, you would do the following:

```sh
cd /sources/active/vim-9.0.0228/src/xxd/
make
sudo strip xxd -o /usr/bin/xxd
cd ../..
sudo install -m644 runtime/doc/xxd.1 /usr/share/man/man1
```

**Note:** `xxd` does not need to be compiled from within vim's source tree.

#### Archival of xxd

If you are keeping the source for all installed software on your system (which I am), you don't need to keep all of vim's source code if you've removed vim but re-installed xxd. Instead, you can do the following, assuming you keep the source archives in `/sources` and use `/sources/active` as a working directory.
```sh
cd /sources/active
mkdir xxd_vim-9.0.0228

cp vim-9.0.0228/{LICENSE,runtime/doc/xxd.1,src/xxd/{xxd.c,Makefile}} xxd_vim-9.0.0228
tar cJvf /sources/xxd_vim-9.0.0228.tar.xz xxd_vim-9.0.0228/
```
