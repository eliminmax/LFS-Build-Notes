# Neovim-8.1

By default, Neovim's makefile downloads 3rd-party dependencies and statically links them. I originally was planning on dynamically linking all of them, but that proved to be a bit too painful. I'm never going to use them for anything other than neovim, so there's not much reason to try to force it. The only ones I'm going to configure it to dynamically link against are libuv, which is included in BLFS, and gettext, which is part of LFS. The build instructions for Neovim explicitly recommend using `ninja` to build it, but I found it hard to get `ninja install` to install it to the `/usr` prefix instead of the `/usr/local` prefix, so I didn't do that.

I was originally planning on replacing vim 9 with neovim, but I decided not to - they each have some things that they do better than the other.

## Dependencies

* libuv (BLFS libuv)

```sh
wget https://github.com/neovim/neovim/archive/refs/tags/v0.8.1.tar.gz -O neovim-0.8.1.tar.gz
tar xf neovim-0.8.1.tar.gz
cd neovim-0.8.1
mkdir .deps
pushd .deps
cmake ../cmake.deps -DUSE_BUNDLED_LIBUV=OFF -DUSE_BUNDLED_GETTEXT=OFF
make -j$(nproc)
popd
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=/usr/lib
make -j$(nproc) ..
sudo make install
```

