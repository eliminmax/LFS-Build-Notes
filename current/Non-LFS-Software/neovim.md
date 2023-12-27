# Neovim

By default, Neovim's makefile downloads 3rd-party dependencies and statically links them. I originally was planning on dynamically linking all of them, but that proved to be a bit too painful. I'm never going to use them for anything other than neovim, so there's not much reason to try to force it. The only ones I'm going to configure it to dynamically link against are libuv, which is included in BLFS, and gettext, which is part of LFS.

## Dependencies

* [blfs/libuv](https://linuxfromscratch.org/blfs/view/12.0/general/libuv.html)
* [blfs/unzip](https://linuxfromscratch.org/blfs/view/12.0/general/unzip.html)

## Package Information

* Download (HTTP): https://github.com/neovim/neovim/archive/refs/tags/v0.9.4.tar.gz

***Note:*** The filename of the download is `v0.9.4.tar.gz`.
If you want it to match the directory contained and/or want it to include the name of the software, rename it to `neovim-0.9.4.tar.gz`.

## Installation

```sh
cmake -S cmake.deps -B .deps -G Ninja \
      -D CMAKE_INSTALL_PREFIX=/usr \
      -D CMAKE_BUILD_TYPE=Release \
      -D USE_BUNDLED_LIBUV=OFF \
      -D USE_BUNDLED_GETTEXT=OFF && \
cmake --build .deps && \
cmake -B build -G Ninja -D CMAKE_BUILD_TYPE=Release \
      -D CMAKE_INSTALL_PREFIX=/usr \
      -D CMAKE_INSTALL_LIBDIR=/usr/lib \
      -D CMAKE_INSTALL_MANDIR=/usr/share/man && \
cmake --build build
```

Then, as `root`, run the following:

```sh
make install
```

## Replace vim with neovim

First, uninstall vim. To do this, re-extract the source, and re-run the same `./configure` command that it was installed with, then run `make uninstall` as root.

Because I installed vim with the LFS instructions, that would look like the following:
```sh
echo '#define SYS_VIMRC_FILE  "/etc/vimrc"' >> src/feature.h 

./configure --prefix=/usr
sudo make uninstall
```

Then, you can either add `vi` and `vim` as symlinks pointing to `nvim` in `/usr/bin`, or, if you find any of the `ex`, `view`, and `vimdiff` commands helpful, you can create a wrapper script that re-creates them by doing the following:

```sh
tmp_nvim_setup_dir="$(mktemp -d)"
cd "$tmp_nvim_setup_dir"
cat > nvim.wrapper <<EOF
#!/bin/sh
case "\$0" in
    */ex) exec nvim -e "\$@" ;;
    */view) exec nvim -R "\$@" ;;
    */vimdiff) exec nvim -d "\$@" ;;
    *) exec nvim "\$@" ;;
esac
EOF
```

Then, as `root`, run the following
```sh
sudo install -dm755 /usr/libexec/neovim
sudo install -m755 nvim.wrapper /usr/libexec/neovim
ln -svf nvim.1 /usr/share/man/man1/vim.1

cd /usr/bin

for i in ex vi vim view vimdiff; do
    ln -vs /usr/libexec/neovim/nvim.wrapper "$i"
done
```

Finally, run the following to clean up the temporary directory created earlier.

```sh
rm -rf "$tmp_nvim_setup_dir"
```

### xxd

If, like me, you still want `xxd` available, you can re-install it.

From within the vim source tree, run the following:

```sh
cd src/xxd/
make
```

Then, as `root`, run the following:

```sh
strip xxd -o /usr/bin/xxd
cd ../..
install -m644 runtime/doc/xxd.1 /usr/share/man/man1
```

**Note:** `xxd` does not need to be compiled from within vim's source tree.

#### Archival of xxd

If you are keeping the source for all installed software on your LFS-based system (which I am), you don't need to keep all of vim's source code if you've removed vim but re-installed xxd. Instead, you can do the following, assuming you keep the source archives.

```sh
cd /sources/active
mkdir xxd_vim-9.0.1677

cp vim-9.0.1677/{LICENSE,runtime/doc/xxd.1,src/xxd/{xxd.c,Makefile}} xxd_vim-9.0.1677
tar cJvf xxd_vim-9.0.1677.tar.xz xxd_vim-9.0.1677/
```
