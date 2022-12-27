# Introduction

I used Linux From Scratch Version 11.2-systemd as a basis for my build, and noted any deviation from its instructions, and difficulties I ran into while working on it.

The original notes, including extensive documentation about the system I used to bootstrap and build the system, is in the file **Original-Build-Notes.md**.

My final system included a few extra pieces of software: OpenSSH and Sudo from BLFS, and a few external programs: BASH completion, the Oil/Osh shell with a personal patch, and Neofetch, an eye-candy system info display tool written in bash.

Originally, this page was a Github Gist I'd edit as I was building the base LFS system, but it got so big that Neovim kept freezing while I was editing it. I split off the part containing the entire Kernel config, copied my notes from the point at which I successfully booted the LFS system, and later removed most of the original notes, because this document was starting to get a bit overwhelming, and the old version was already saved to the other file.

# Table of Contents

- [Introduction](#introduction)
- [Table of Contents](#table-of-contents)
- [Additional Software from BLFS](#additional-software-from-blfs)
  * [Notes on specific software](#notes-on-specific-software)
    + [Wget-1.21.3](#wget-1213)
    + [cURL-7.84.0](#curl-7840)
    + [Git-2.37.2](#git-2372)
    + [Linux-PAM-1.5.2](#linux-pam-152)
    + [Rustc-1.60.0](#rustc-1600)
    + [Polkit-121](#polkit-121)
    + [UPower-1.90.0](#upower-1900)
    + [Mesa](#mesa)
    + [libtiff-4.4.0](#libtiff-440)
    + [librsvg-2.54.4](#librsvg-2544)
- [External software](#external-software)
  * [renameutils 0.12.0](#renameutils-0120)
  * [libevent 2.1.12](#libevent-2112)
  * [tmux 3.3a](#tmux-33a)
  * [byobu 5.133](#byobu-5133)
  * [Nerd Fonts v2.2.2](#nerd-fonts-v222)
  * [lshw B.02.19.2](#lshw-b02192)
  * [bat 0.22.1](#bat-0221)
  * [hexyl 0.12.0](#hexyl-0120)
  * [fd 8.6.0](#fd-860)
  * [Hed [Commit 44d3eb7]](#hed-commit-44d3eb7)
  * [Xorg Drivers and Guest utilities](#xorg-drivers-and-guest-utilities)
    + [spice-protocol](#spice-protocol)
    + [usbredir](#usbredir)
    + [SPICE (Server) + Dependencies](#spice-server--dependencies)
    + [xf86-video-qxl + xspice](#xf86-video-qxl--xspice)
    + [spice-vdagent](#spice-vdagent)
      - [QEMU Guest Agent](#qemu-guest-agent)
- [Software updates](#software-updates)
- [Miscellaneous Issues](#miscellaneous-issues)
  * [End of chapter 8 crisis](#end-of-chapter-8-crisis)
  * [Kernel config woes](#kernel-config-woes)
  * [SSH X forwarding](#ssh-x-forwarding)
  * [Kernel config woes (again)](#kernel-config-woes-again)
  * [Locale](#locale)

# Additional Software from BLFS

Unless otherwise noted, I installed all required and recommended dependencies listed in the BLFS book, and did not specifically install optional dependencies. I did not write about every single package installed.

After building Git-2.37.2, I got into the swing of things.

The software I built from BLFS was all either one of the following, or a required or recommended dependency of something I specifically mention. If I built something from outside of BLFS with a dependency that is in BLFS, I noted it in the write-up in the section on non B/LFS software.

Whenever I built something with meson, I'd pass it the arguments `-Dlibdir=/usr/lib -Dbackend=ninja -Dstrip=true -Ddebug=false`. Before I started to do that, it would install libraries to /usr/lib64, which I did not want. The other arguments are there just because.

The programs I installed from BLFS for their own sake (i.e. not as a dependency) are as follows:

* Wget-1.21.3
* cURL-7.84.0
* Git-2.37.2
* Rustc-1.60.0
* lsof-4.95.0
* xmlto-0.0.28
* sharutils-4.15.2
* xdg-user-dirs-0.18
* Python Modules
  * asciidoc-10.2.0
* xterm-372
* xclock-1.1.1
* xfce4-session-4.16.0
* tree-2.0.3

## Notes on specific software

### Wget-1.21.3

Built this with optional dependencies libidn2, libpsl, and pcre2

### cURL-7.84.0

`CMake` can use its own version of `curl`, or the system `curl`. At the same time, `curl` has optional dependencies on `c-ares` and `brotli`, both of which require `CMake` to build. I already had the optional dependencies `libidn2` and `libpsl` installed. The order I built them in is as follows:

1. LZO
2. libuv
3. libxml2
4. Nettle
5. libssh2
6. nghttp2
7. libarchive
8. CMake
9. curl
10. CMake
11. c-ares
12. brotli
13. curl

### Git-2.37.2

Bit of a large dependency tree - none required, but I wanted to include some of them.

**Dependencies that were already installed**

* cURL
* OpenSSH
* pcre2
* Nettle
* make-ca
* libunistring
* libtasn1
* p11-kit
* libidn2

**Unresolved dependency installation order**

1. npth
2. libusb
3. libgpg-error
4. Pth
5. Net-tools
6. libassuan
7. libgcrypt
8. libksba
9. GnuTLS
10. pinentry
11. GnuPG

### Linux-PAM-1.5.2

I messed up this one.

I compiled Linux-PAM, then I recompiled the following to use it:
* Systemd
* libcap
* Sudo
* Shadow
* OpenSSH

Unfortunately, I messed up the order, and couldn't do anything that required root privileges.

I had to mount the LFS VM's qcow2 hard drive from the host system with `guestmount` and chroot in to fix the configuration files at */etc/pam.d*.

### Rustc-1.60.0

I removed the part of */etc/profile.d/rustc.sh* that edits MANPATH, because if MANPATH is unset, it will check any *share/man* subdirectory in the same directory as a directory in the PATH, so it's not necessary, and prevents `man` from finding manpages in */usr/share/man*.

### Polkit-121

Dependency of UPower, which is a dependency of xfce4-power-manager. Failed to build because it detected libxslt, but could not build the man pages without docbook-xml and docboc-xml-nons. There's a note about it in BLFS (which I overlooked), which says to pass the `-Dman=false` argument to `meson` to avoid the issue. I was able to fix it by re-running the `meson` command with `-Dman=true` replaced with `-Dman=false` and `--reconfigure` added to the command.

### UPower-1.90.0

Required a kernel built with `CONFIG_USER_NS=y`, so I had to rebuild the kernel. The result was `5.19.2-eliminmax-2`.

### Mesa

I didn't apply the patch, because I misread the description more carefully. I thought it only was needed for the test suite, which I skipped.

I later rebuilt it with the patch, but also added another patch to fix an issue it has with virgl. The final build is as follows:

```sh
# After acquiring the source and patches from the BLFS book
wget https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/18477.patch -O mesa-virgl-18477.patch
tar xf mesa-22.1.7.tar.xz
cd mesa-22.1.7
patch -Np1 -i ../mesa-virgl-18477.patch
patch -Np1 -i ../mesa-22.1.7-add_xdemos-1.patch
mkdir build && cd build &&
meson --prefix=$XORG_PREFIX \
  --buildtype=release       \
  -Dlibdir=/usr/lib         \
  -Dbackend=ninja           \
  -Dstrip=true              \
  -Ddebug=false             \
  -Dplatforms=x11,wayland   \
  -Dgallium-drivers=auto    \
  -Dglx=dri                 \
  -Dvalgrind=disabled       \
  -Dlibunwind=disabled      \
  ..                        &&
ninja && sudo ninja install
```

### libtiff-4.4.0

Recommended dependency of gdk-pixbuf, which in turn is a required dependency of GTK+ 3. Part of the dependency tree for

Originally built according to the BLFS instructions, but that installed the libraries to /usr/lib64, but I want all libraries installed to /usr/lib.

I then deleted all of the files it installed, and rebuilt and reinstalled it with the GNU tools (i.e. `/configure --disable-static --prefix=/usr --sysconfdir=/etc --localstatedir=/var --docdir=/usr/share/doc/tiff-4.4.0 --libdir=/usr/lib && make && sudo make install`)

### librsvg-2.54.4

Recommended runtime dependency for gdk-pixbuf

The `make install` job for this requires `cargo`, which is installed to /opt/rustc/bin. When running `sudo`, the PATH is altered, so it failed to install because `/opt/rustc/bin` was removed from the path. I fixed it by editing the sudoers configuration with `sudo visudo`, and uncommented the `Defaults secure_path` line, and edited it as follows:

```sudoers
Defaults secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/opt/rustc/bin"
```

After that, it worked fine.

# External software

The software listed here was not from the BLFS book. For each piece of software, I have a shell snippet that should build and install it. That said, I make no promises. I also assume you have an LFS system with Git, Sudo, and Wget installed. The snippets are designed with the assumption that every command succeeds, so it should be run in a `bash -e` shell, so that it exits on error. Note that I did not run the code snippets myself - I made them afterwards by retracing my steps.

## renameutils 0.12.0

Simple tools to bulk rename and bulk copy files:

* `qmv` lets you quickly move large numbers of file s using a text editor. I use it all the time.
* `imv` lets you rename a file by editing its name using `readline`
* `qcp` and `icp` are like `qmv` and `imv`, but let you copy files instead of moving them
* `deurlname` renames a file, replacing URL-encoded characters (like `%20`) with their plain-text equivalent.

This one looked like it'd be simple enough - the instructions were to just run `./configure`, `make`, then `make install`. Unfortunately, due to a typo in the Makefile, the `make install` failed. I figured I could look into the way it was built for established distros, so on my host system, I ran `apt source renameutils` to download the source that the Pop!_OS build is made from, and found 2 patches - `install-exec-local-fix.patch` and `typo_fix.patch`. Applying those patches in that order right after extracting the `renameutils` source archive fixed it.

Build instructions:

```sh
wget https://download.savannah.gnu.org/releases/renameutils/renameutils-0.12.0.tar.gz
wget https://sources.debian.org/data/main/r/renameutils/0.12.0-9/debian/patches/install-exec-local-fix.patch -O renameutils-install-exec-local-fix.patch
wget https://sources.debian.org/data/main/r/renameutils/0.12.0-9/debian/patches/typo_fix.patch -O renameutils-typo_fix.patch
tar xf renameutils-0.12.0.tar.gz
cd renameutils-0.12.0
patch -Np1 ../renameutils-install-exec-local-fix.patch
patch -Np1 ../renameutils-typo_fix.patch
./configure                                   \
  --prefix=/usr                               \
  --sysconfdir=/etc                           \
  --docdir=/usr/share/doc/renameutils-0.12.0 &&
  make
sudo make install
```

## libevent 2.1.12

Libevent is a dependency for `tmux`, itself a dependency for `byobu`.
The source archive is available at https://github.com/libevent/libevent/releases/download/release-2.1.12-stable/libevent-2.1.12-stable.tar.gz

Building is simple:

```sh
wget https://github.com/libevent/libevent/releases/download/release-2.1.12-stable/libevent-2.1.12-stable.tar.gz
tar xf libevent-2.1.12-stable.tar.gz
cd libevent-2.1.12-stable
./configure --prefix=/usr --sysconfdir=/etc --disable-static
make
sudo make install
```

## tmux 3.3a

A **t**erminal **mul**tiplexer with an uncreative name. Used as a back-end by `byobu` - a "terminal window manager" I often use when multitasking.

```sh
wget https://github.com/tmux/tmux/releases/download/3.3a/tmux-3.3a.tar.gz
tar xf tmux-3.3a.tar.gz
cd tmux-3.3a
./configure --prefix=/usr --sysconfdir=/etc --docdir=/usr/share/doc/tmux-3.3a
make
sudo make install
```

## byobu 5.133

A "terminal window manager" that I like to use for multitasking. Uses either GNU `screen` or `tmux` as a back-end. The `byobu-config` script has runtime dependency on snack, a part of the newt package, which depends on popt and s-lang. S-lang (a.k.a. slang) has optional dependencies on PCRE, libpng, oniguruma, and zlib. Zlib is part of the base LFS system, and PCRE and libpng are in BLFS. Once the dependencies covered in B/LFS are built, you can run the following to build byobu and its runtime dependencies.

```sh
wget https://ftp.osuosl.org/pub/rpm/popt/releases/popt-1.x/popt-1.19.tar.gz
wget https://github.com/kkos/oniguruma/releases/download/v6.9.8/onig-6.9.8.tar.gz
wget https://www.jedsoft.org/releases/slang/slang-2.3.3.tar.bz2
wget https://pagure.io/newt/archive/r0-52-23/newt-r0-52-23.tar.gz
wget https://launchpad.net/byobu/trunk/5.133/+download/byobu_5.133.orig.tar.gz

tar -xf popt-1.19.tar.gz
pushd popt-1.19
./configure --disable-static --prefix=/usr --sysconfdir=/etc --localstatedir=/var --docdir=/usr/share/doc/popt-1.19
make
sudo make install
popd

tar xf onig-6.9.8.tar.gz
pushd onig-6.9.8
./configure --disable-static --prefix=/usr --sysconfdir=/etc --localstatedir=/var --docdir=/usr/share/doc/onig-6.9.8
make
sudo make install
popd

tar xf slang-2.3.3.tar.bz2
pushd slang-2.3.3
./configure --disable-static --prefix=/usr --sysconfdir=/etc --localstatedir=/var --docdir=/usr/share/doc/slang-2.3.3
make
sudo make install
popd

tar xf newt-r0-52-23.tar.gz
pushd newt-r0-52-23
./configure --disable-static --prefix=/usr --sysconfdir=/etc --localstatedir=/var --docdir=/usr/share/doc/newt-40-52-23
make
sudo make install
popd

tar xf byobu_5.133.orig.tar.gz
cd byobu_5.133
./configure --prefix=/usr --sysconfdir=/etc --docdir=/usr/share/doc/byobu-5.133 --localstatedir=/var
make
sudo make install
```

## Nerd Fonts v2.2.2

Fonts patched to have symbols useful in various nerdy contexts - such as Linux distro logos, file type icons, and fancy prompt components.

```sh
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/VictorMono.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/UbuntuMono.zip
mkdir nerdfonts
cd nerdfonts
unzip ../VictorMono.zip
yes n | unzip ../UbuntuMono.zip
# remove unneeded files and variants
rm readme.md LICENSE *Windows\ Compatible.ttf *Complete.ttf
sudo install -v -dm755 /usr/share/fonts/X11-TTF
sudo cp * /usr/share/fonts/X11-TTF
```

## lshw B.02.19.2

Simple tool to list hardware info.
```sh
wget https://www.ezix.org/software/files/lshw-B.02.19.2.tar.gz
tar xf lshw-B.02.19.2.tar.gz
cd lshw-B.02.19.2
make
sudo make install
sudo mv /usr/share/man/man1/lshw.1 /usr/share/man/man8/lshw.8
sudo sed -i '/^\.TH/s/"1"/"8"/' /usr/share/man/man8/lshw.8
```

Installs the `lshw` binary to /usr/sbin, as well as other related files.

The `sed` command at the end fixes the man page section.

## bat 0.22.1

Source tarball: https://github.com/sharkdp/bat/archive/refs/tags/v0.22.1.tar.gz

```sh
wget https://github.com/sharkdp/bat/archive/refs/tags/v0.22.1.tar.gz -O bat-0.22.1.tar.gz
tar xf bat-0.22.1.tar.gz
cd bat-0.22.1
cargo build --release --bins --locked
sed -e 's/{{PROJECT_EXECUTABLE}}/bat/g' -e 's/{{PROJECT_EXECUTABLE_UPPERCASE}}/BAT/g' assets/manual/bat.1.in > assets/manual/bat.1
sudo strip target/release/bat -o /usr/bin/bat
sudo cp assets/manual/bat.1 /usr/share/man/man1
```

Explanation:

* `cargo build`: download dependencies from the official Rust Crates archive to the local registry and build
* `--release`: enable optimizations that can complicate debugging
* `--bins`: build all binaries
* `--locked`: use the same versions of dependencies as the upstream build

## hexyl 0.12.0

A hex-dump utility with colors and fancy output

```sh
wget https://github.com/sharkdp/hexyl/archive/refs/tags/v0.12.0.tar.gz -O hexyl-0.12.0.tar.gz
tar xf hexyl-0.12.0.tar.gz
cd hexyl-0.12.0
cargo build --release --bins --locked
sudo strip target/release/hexyl -o /usr/bin/hexyl
```

## fd 8.6.0

An alternative to `find` that's easier to use and has saner defaults

```sh
wget https://github.com/sharkdp/fd/archive/refs/tags/v8.6.0.tar.gz -O fd-8.6.0.tar.gz
tar xf fd-8.6.0.tar.gz
cd fd-8.6.0
cargo build --release --bins --locked
sudo strip target/release/fd -o /usr/bin/fd
sudo cp doc/fd.1 /usr/share/man/man1
```

## Hed [Commit 44d3eb7]

A simple vi-like hex editor with minimal dependencies

This one's designed to install from the `master` branch. Not great practice, but whatever.

```sh
git clone https://github.com/fr0zn/hed hed-44d3eb7
cd hed-44d3eb7
# ensure you're on the same commit I was working from
git checkout 44d3eb7
# fix hard-coded paths in the Makefile
sed 's@local/@@g' -i Makefile
make
sudo make install
# create source tarball for safekeeping
cd ..
tar --exclude-vcs --exclude-vcs-ignores -czvf hed-44d3eb7.tar.gz hed-44d3eb7
```


## Xorg Drivers and Guest utilities

This section contains Xorg drivers not from B/LFS, as well as assorted tools to allow for better performance of the LFS system, and better interaction with the host system.

Finding out what Xorg drivers to build, and how to build them, was a pain. I was able to find some work-in-progress BLFS pages [here](https://wiki.linuxfromscratch.org/blfs/wiki/qemu), but they were out of date, and the build process for spice-protocols had been changed.

### spice-protocol

```sh
wget https://gitlab.freedesktop.org/spice/spice-protocol/-/archive/v0.14.4/spice-protocol-v0.14.4.tar.bz2
tar xf spice-protocol-v0.14.4.tar.bz2
cd spice-protocol-v0.14.4
mkdir build && cd build
meson -Dlibdir=/usr/lib -Dbackend=ninja -Dstrip=true -Ddebug=false --buildtype=release --prefix=/usr ..
sudo ninja install
```

### usbredir

* Depends on libusb and GLib. GLib requires libxslt, which in turn requires libxml2. All of those are covered in BLFS.

```sh
wget https://www.spice-space.org/download/usbredir/usbredir-0.13.0.tar.xz
tar xf usbredir-0.13.0.tar.xz
cd usbredir-0.13.0
mkdir build && cd build
meson -Dlibdir=/usr/lib -Dbackend=ninja -Dstrip=true -Ddebug=false --buildtype=release --prefix=/usr ..
ninja
sudo ninja install
```

### SPICE (Server) + Dependencies

To quote the README:

> SPICE is a remote display system built for virtual environments which
> allows you to view a computing 'desktop' environment not only on the
> machine where it is running, but from anywhere on the Internet and
> from a wide variety of machine architectures.

* Depends on spice-protocol, Pixman, OpenSSL, libjpeg, and zlib for core functionality. Optional dependencies are Cyrus-SASL, libcacard, Opus, LZ4, and GStreamer. The base LFS system has OpenSSL and zlib. BLFS has pages on libjpeg-turbo (which works as libjpeg), Pixman, GStreamer, and Opus. That leaves lz4, Cyrus-SASL, libcacard, and the previously-built spice-protocol.

libcacard is used to provide virtual smart cards, which I do not intend to use. I did build it with the other dependencies.

SPICE, along with the remaining dependencies from outside of B/LFS, can be built as follows:

```sh
wget https://github.com/cyrusimap/cyrus-sasl/releases/download/cyrus-sasl-2.1.28/cyrus-sasl-2.1.28.tar.gz
tar xf cyrus-sasl-2.1.28.tar.gz
pushd cyrus-sasl-2.1.28
./configure --disable-static --prefix=/usr --sysconfdir=/etc --localstatedir=/var --docdir=/usr/share/doc/"$(basename "$PWD")"
make
sudo make install
popd
wget https://github.com/lz4/lz4/archive/refs/tags/v1.9.4.tar.gz -O lz4-1.9.4.tar.gz
tar xf lz4-1.9.4.tar.gz
pushd lz4-1.9.4
make
sudo make PREFIX=/usr install
# delete static lib
sudo rm /usr/lib/liblz4.a
popd
wget https://gitlab.freedesktop.org/spice/spice/uploads/5b40fad4ec02e7983c182a24266541f5/spice-0.15.1.tar.bz2
tar xf spice-0.15.1.tar.bz2
cd spice-0.15.1
./configure --disable-static --prefix=/usr --sysconfdir=/etc --localstatedir=/var --docdir=/usr/share/doc/"$(basename "$PWD")" --enable-gstreamer=/usr/lib/libgstreamer-1.0.so
make
sudo make install
```

Note that it fails to detect GStreamer on my system unless I manually specify the path as shown above.

### xf86-video-qxl + xspice

* Depends on spice-protocol and xorg-server, with an optional dependency on SPICE (the spice server) for the xspice functionality, which I use.

Has not had a release in years, and segfaults on modern versions of xorg. The Git repository is active, and patches to fix the issue are available.

The following works currently, as of upstream git commit `52e975263fe88105d151297768c7ac675ed94122`.

```sh
git clone https://gitlab.freedesktop.org/xorg/driver/xf86-video-qxl.git
pushd xf86-video-qxl
git remote add jmbreuer https://gitlab.freedesktop.org/jmbreuer/xf86-video-qxl.git
git fetch jmbreuer
git merge jmbreuer/fix-xorg-server-21
./autogen.sh
./configure $XORG_CONFIG --enable-xspice=yes
make
sudo make install
popd
# Create a source tarball for safekeeping
tar cvzf xf86-video-qxl.tar.gz --exclude-vcs --exclude-vcs-ignores xf86-video-qxl
# point the /usr/bin/X symlink to Xspice
sudo ln -sf Xspice /usr/bin/X
```

### spice-vdagent

* Depends on spice-protocol, alsa-lib, and libinput, and libinput in turn depends on libevdev and mtdev. Both libinput and libevdev can be found on the Xorg Drivers page of BLFS, while alsa-lib and mtdev have their own BLFS pages.

```sh
wget https://www.spice-space.org/download/releases/spice-vdagent-0.22.1.tar.bz2
tar xf spice-vdagent-0.22.1.tar.bz2
cd spice-vdagent-0.22.1
./configure --disable-static --prefix=/usr --sysconfdir=/etc --localstatedir=/var --docdir=/usr/share/doc/spice-vdagent-0.22.1 --with-init-script=systemd
make
sudo make install
```

#### QEMU Guest Agent

This one was not in the WIP BLFS page linked earlier. I came up with it myself by referencing the QEMU docs and the metadata and contents of the **qemu-guest-agent** package in [Martin Wimpress's quickemu PPA on launchpad](https://launchpad.net/~flexiondotorg/+archive/ubuntu/quickemu/+packages).

I decided to build version 7.0.0, because it matches the version of QEMU on the host system. I don't know if that was needed, but it can't hurt. Depends on liburing2, a library that provides a simplified interface to the Linux kernel's io_uring functionality. I don't know what that means, but whatever.
Build and install liburing2 and qemu-ga:

```sh
wget https://github.com/axboe/liburing/archive/refs/tags/liburing-2.3.tar.gz
tar xf liburing-2.3.tar.gz
pushd liburing-liburing-2.3
./configure --prefix=/usr --libdir=/usr/lib --mandir=/usr/share/man
make
sudo make install
sudo strip /usr/lib/liburing.so.2.3
popd
wget https://download.qemu.org/qemu-7.0.0.tar.xz
tar xf qemu-7.0.0.tar.xz
pushd qemu-7.0.0
./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --libdir=/usr/lib --docdir=/usr/share/doc/"$(basename "$PWD")" --without-default-features --enable-guest-agent --without-default-devices
make qemu-ga
sudo strip build/qga/qemu-ga -o /usr/sbin/qemu-ga
popd
sudo dd of=/usr/lib/systemd/system/qemu-guest-agent.service <<EOF
[Unit]
Description=QEMU Guest Agent
BindsTo=dev-virtio\x2dports-org.qemu.guest_agent.0.device
After=dev-virtio\x2dports-org.qemu.guest_agent.0.device

[Service]
ExecStart=-/usr/sbin/qemu-ga
Restart=always
RestartSec=0

[Install]
EOF

sudo dd of=/usr/lib/udev/rules.d/60-qemu-guest-agent.rules <<EOF
SUBSYSTEM=="virtio-ports", ATTR{name}=="org.qemu.guest_agent.0",  TAG+="systemd" ENV{SYSTEMD_WANTS}="qemu-guest-agent.service"
EOF
```

After rebooting the system, the QEMU guest agent ran just fine


# Software updates

Newer versions of software installed previously as part of B/LFS

Mostly updated because of security vulnerabilities mentioned on the page listing [LFS and BLFS Security Advisories from September 2020 onwards](https://linuxfromscratch.org/blfs/advisories/consolidated.html)

* Linux 6.1.1
* libksba-1.6.3
* libtiff-4.4.0
  * rebuilt with a patch added from the development version of BLFS to fix security vulnerabilities, and with the additional option `-DCMAKE_INSTALL_LIBDIR=/usr/lib`
* curl-7.86.0
* Python-3.11.1
  * After updating I had to rebuild the following modules:
    * asciidoc
    * docutils
    * Jinja2
    * LSB-Tools
    * Mako
    * MarkupSafe
    * meson
    * Pygments
    * PyYAML
    * wheel
  * In addition, I had to rebuild the following packages that provide python modules:
    * newt (not from B/LFS, mentioned earlier)
    * gobject-introspection
    * xcb-proto
* Sudo-1.9.12p1
* git-2.39.0
* xorg-server-21.1.6
* xfce4-settings-4.16.5
* polkit-122
  * polkit-121 has a hard-coded list of supported Javascript engines, and the supported Mozilla JS engine, the one included in BLFS, reached end-of-life in September 2022, and has a known use-after-free vulnerability which can cause a "potentially exploitable crash." ([CVE-2022-45406](https://nvd.nist.gov/vuln/detail/CVE-2022-45406))

# Miscellaneous Issues

The first two entries of this are from my original build notes, but after that, I've added a few new ones.

## End of chapter 8 crisis

At the end of chapter 8, in **8.79. Stripping**, I blindly copied in the commands that it listed, and that turned out to be a major problem, because I updated zlib to version 1.
2.13, and it was set up to skip stripping a list of hard-coded libraries, which was still on 1.2.12. The `strip` binary depends on zlib, and somehow, when trying to strip its own dependency, `/usr/lib/libz.so.1.2.13` was overwritten, and was now an empty file. I had deleted the old zlib build directory, and had to restart from step one, but the `./configure` command failed without zlib already available. What I wound up doing was leaving the chroot environment, copying `/usr/lib/libz.so.1.2.11` from the build VM to the chroot, pointing the `/usr/lib/libz.so` and `/usr/lib/libz.so.1` symlinks to that, and rebuilding zlib, reverting the symlinks, rebuilding it yet again, then confirming that the one build with zlib 1.2.11 and the one build with zlib 1.2.13 were byte-for-byte identical.

Later on, I realized that by stripping the `/usr/bin/oil.ovm` binary, I'd accidentally broken it. All it did when run was print the following:

```
FATAL: couldn't import from app bundle oil.ovm' (-1)
Stripping the oil.ovm binary may cause this error.
See https://github.com/oilshell/oil/issues/47
```
Whoops.

Luckily, it was a quick and easy process to rebuild and reinstall.

## Kernel config woes

It took me a bit of experimentation to find a kernel configuration that worked, and properly configure grub, but I got there in the end - sort of. My system is bootable, but I need to manually enable the networking drivers with `modprobe` - I will rebuild it eventually, but in the meantime, adding `virtio` and `virtio_net` to `/etc/modules` should be able to ensure things work out of the box.

## SSH X forwarding

Turns out that I should have read the page on OpenSSH more carefully and/or planned ahead better. I needed to point it to the `xauth` binary in the sshd_config file, but if I'd passed the `--with-xauth=/usr/bin/xauth` flag, that wouldn't be needed. Was an easy fix regardless.

## Kernel config woes (again)

When rebuilding the kernel for UPower, when adjusting the included drivers, I managed to accidentally remove the drivers used by the VM. The VM saw the drive as a SATA device. I removed the drive from the VM, and re-added it as a virtio drive. This not only worked fine, but also improves performance.


## Locale

`localectl` wasn't working, so I wound up manually writing the following to /etc/locale.conf:

```
LANG=en_US.UTF-8
LC_ADDRESS=en_US.UTF-8
LC_CTYPE=en_US.UTF-8
LC_MEASUREMENT=en_US.UTF-8
LC_MONETARY=en_US.UTF-8
LC_NUMERIC=en_US.UTF-8
LC_TELEPHONE=en_US.UTF-8
LANGUAGE=en_US.UTF-8
LC_COLLATE=en_US.UTF-8
LC_IDENTIFICATION=en_US.UTF-8
LC_MESSAGES=en_US.UTF-8
LC_NAME=en_US.UTF-8
LC_PAPER=en_US.UTF-8
LC_TIME=en_US.UTF-8
```

Additionally, I created `/etc/profile.d/locale.sh`, which I based on the same file in an Arch Linux VM (appropriately called "btw"). The only change I made was changing the fallback locale from `C` to `C.UTF-8`. Its contents are as follows:

```sh
#!/bin/sh

# load locale.conf in XDG paths.
# /etc/locale.conf loads and overrides by kernel command line is done by systemd
# But we override it here, see FS#56688
if [ -z "$LANG" ]; then
  if [ -n "$XDG_CONFIG_HOME" ] && [ -r "$XDG_CONFIG_HOME/locale.conf" ]; then
    . "$XDG_CONFIG_HOME/locale.conf"
  elif [ -n "$HOME" ] && [ -r "$HOME/.config/locale.conf" ]; then
    . "$HOME/.config/locale.conf"
  elif [ -r /etc/locale.conf ]; then
    . /etc/locale.conf
  fi
fi

# define default LANG to C.UTF-8 if not already defined
LANG=${LANG:-C.UTF-8}

# export all locale (7) variables when they exist
export LANG LANGUAGE LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY \
       LC_MESSAGES LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT \
       LC_IDENTIFICATION
```
