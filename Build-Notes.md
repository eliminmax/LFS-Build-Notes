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
    + [xdg-utils-1.1.3](#xdg-utils-113)
    + [Node.js-18.12.1](#nodejs-18121)
    + [Firefox-102.6.0esr](#firefox-10260esr)
    + [xorg-server 21.1.6](#xorg-server-2116)
    + [libtiff-4.5.0](#libtiff-450)
- [External software](#external-software)
  * [Notes on specific software](#notes-on-specific-software-1)
    + [renameutils 0.12.0](#renameutils-0120)
    + [libevent 2.1.12](#libevent-2112)
    + [tmux 3.3a](#tmux-33a)
    + [byobu 5.133](#byobu-5133)
    + [Nerd Fonts v2.2.2](#nerd-fonts-v222)
    + [lshw B.02.19.2](#lshw-b02192)
    + [bat 0.22.1](#bat-0221)
    + [hexyl 0.12.0](#hexyl-0120)
    + [fd 8.6.0](#fd-860)
    + [Hed [Commit 44d3eb7]](#hed-commit-44d3eb7)
    + [Xorg Drivers and Guest utilities](#xorg-drivers-and-guest-utilities)
      - [spice-protocol](#spice-protocol)
      - [usbredir](#usbredir)
      - [SPICE (Server) + Dependencies](#spice-server--dependencies)
      - [xf86-video-qxl + xspice](#xf86-video-qxl--xspice)
      - [spice-vdagent](#spice-vdagent)
      - [QEMU Guest Agent](#qemu-guest-agent)
      - [x-resize](#x-resize)
    + [Neovim-8.1](#neovim-81)
    + [the silver searcher (ag)](#the-silver-searcher-ag)
    + [Git 2.39.0 Bash Completion](#git-2390-bash-completion)
    + [Whisker Menu](#whisker-menu)
    + [Papirus icon theme 20221201](#papirus-icon-theme-20221201)
    + [kitty-0.26.5](#kitty-0265)
    + [BPython](#bpython)
    + [pfetch-0.6.0](#pfetch-060)
    + [LightDM GTK+ Greeter Settings](#lightdm-gtk-greeter-settings)
    + [Materia Compact GTK Theme](#materia-compact-gtk-theme)
- [Software updates](#software-updates)
  * [B/LFS](#blfs)
- [Miscellaneous Issues](#miscellaneous-issues)
  * [End of chapter 8 crisis](#end-of-chapter-8-crisis)
  * [Kernel config woes](#kernel-config-woes)
  * [SSH X forwarding](#ssh-x-forwarding)
  * [Kernel config woes (again)](#kernel-config-woes-again)
  * [Locale](#locale)
  * [Updates on the evening of Friday December 30th 2022 EST](#updates-on-the-evening-of-friday-december-30th-2022-est)
  * [Broken Polkit Authorization](#broken-polkit-authorization)
  * [Failure to start systemd-oomd](#failure-to-start-systemd-oomd)

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
* xfce4-notifyd-0.6.3
* Ristretto-0.12.3
* xfce4-pulseaudio-plugin-0.4.3
* lynx-2.8.9rel.1
* xdg-utils-1.1.3
* LXAppearance-0.6.3
* lightdm-1.32.0

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

### xdg-utils-1.1.3

Has a known vulnerability ([CVE-2020-27748](https://access.redhat.com/security/cve/cve-2020-27748)), which is described as follows:

> A flaw was found in the xdg-email component of xdg-utils-1.1.0-rc1 and newer.
> When handling mailto: URIs, xdg-email allows attachments to be discreetly added via the URI when being passed to Thunderbird.
> An attacker could potentially send a victim a URI that automatically attaches a sensitive file to a new email.
> If a victim user does not notice that an attachment was added and sends the email, this could result in sensitive information disclosure.
> It has been confirmed that the code behind this issue is in xdg-email and not in Thunderbird.

The solution offered is rather inadequate, in my opinion.

> To mitigate this flaw, either:
> 1. Do not use mailto links at all
> 2. Always double-check in the user interface that there are no unwanted attachments before sending emails; especially when the email originates from clicking a mailto link.

Given that, from what I've read, the attachment handling in xdg-email is broken for email clients other than Thunderbird, and only works on specific desktop environments with Thunderbird, I see no harm in removing its attachment-handling code.

There's an open merge request to do just that in the xdg-utils gitlab repo ([merge request #58](https://gitlab.freedesktop.org/xdg/xdg-utils/-/merge_requests/58/diffs)), and I was able to apply it, even though it is for the master branch as of 4 months ago, rather than release 1.1.3. It does print a message reading "`Hunk #2 succeeded at 330 (offset -3 lines).`", but works anyway.

To download the patch, run `wget https://gitlab.freedesktop.org/xdg/xdg-utils/-/merge_requests/58.patch -O xdg-utils-58-no-mail-attach.patch` from within the source directory's parent.

To apply it, run `patch -Np1 -i ../xdg-utils-58-no-mail-attach.patch` from within the source directory.

After that, I built it according to the BLFS instructions.

### Node.js-18.12.1

The version included in the BLFS book 11.2-systemd (16.17.0) a security vulnerability patched in newer versions. I built version 18.12.1 instead, using the instructions in the unstable r11.2-692 version of the book.

The only difference in the build instructions is that it includes instructions to make the configure script work with Python 3.11:

```sh
sed -e '/=.*exec/a command -v python3.11 >/dev/null && exec python3.11 "$0" "$@"' \
    -e s'/((/((3, 11), (/'  \
    -i configure
```

### Firefox-102.6.0esr

The version of firefox in BLFS 11.2-systemd (102.2.0esr) has vulnerabilities that have been fixed in 102.6.0esr. The build process has an extra step when building with Python3.11.

Before running the `./mach configure && ./mach build` command sequence, follow the following excerpt from BLFS Systemd Version r11.2-709:
>  First remove an obsolete flag in python code, that has been removed in python-3.11:
>
> ```sh
> grep -rl \"rU\" | xargs sed -i 's/"rU"/"r"/'
> ```
>
> Then fix an issue with regular expressions in python-3.11:
>
> ```sh
> sed -e 's/?s)\./?s:.)/'               \
>     -e '/?m)/{s/?m)/?m:/;s/\$"/$)"/}' \
>     -e '/?s)%/{s/?s)/?s:/;s/?"/?)"/}' \
>     -i xpcom/idl-parser/xpidl/xpidl.py
> ```

### xorg-server 21.1.6

Rebuilt at a later point with xcb-util-keysyms-0.4.0, xcb-util-image-0.4.0, xcb-util-renderutil-0.3.9, and xcb-util-wm-0.4.1 installled to enable the installation of Xephyr.

### libtiff-4.5.0

When updating, I was able to install using the instructions that I'd previously been stuck with, by passing the flag `-DCMAKE_INSTALL_LIBDIR=/usr/lib` to cmake. I'm learning.

# External software

The software listed here was not from the BLFS book. For each piece of software, I have a shell snippet that should build and install it. That said, I make no promises. I also assume you have an LFS system with Git, Sudo, and Wget installed. The snippets are designed with the assumption that every command succeeds, so it should be run in a `bash -e` shell, so that it exits on error, rather than continue silently.. Note that unless otherwise noted, I did not run the code snippets myself - I made them afterwards by retracing my steps.

Once it got to be too much to keep track of what I was actively working on, I created a `/sources/active` directory. When I first download source tarballs, I download them there, extract them, and once the build is complete, delete the source directory, and move the source tarball up to the `/sources` directory. That last part is not included in the shell snippets below.

If the source archive is a zip file, rather than a tarball, I create a target directory with the same name as the zip file, and extract it into that, then create a tarball of that, and remove the zip file.

For example:

```sh
wget https://src.example.org/foo/libfoo.zip
mkdir libfoo
cd libfoo
unzip ../libfoo.zip
### build and install libfoo
cd ..
tar --use-compress-program=xz cf libfoo.tar.xz libfoo- --exclude-vcs-ignores --exclude-vcs
rm -rf libfoo libfoo.zip
```

If the code is installed from the master branch of a Git repository, instead of downloading a tarball, I have an alternate process:

1. find a known-good commit, and clone the repo to a directory called `<reponame>-<commit>`
2. build it
3. build a source tarball, passing the flags `--exclude-vcs-ignores --exclude-vcs` to tar to get a somewhat clean specimen for the source archive.

For example:

```sh
git clone https://git.example.org/foo/libfoo.git libfoo-e1a6d82
cd libfoo-e1a6d82
git checkout e1a6d82
### build and install libfoo
cd ..
tar --use-compress-program=xz cf libfoo-e1a6d82.tar.xz libfoo-e1a6d82 --exclude-vcs-ignores --exclude-vcs
rm -rf libfoo-e1a6d82
```

Patches, once used, should be compressed with xz. Copies of downloaded stand-alone scripts, like x-resize, should be kept in the `/sources` directory and xz-compressed.

Gzip'ed and Bzip2'ed tarballs should be decompressed and recompressed with xz.

## Notes on specific software

### renameutils 0.12.0

Simple tools to bulk rename and bulk copy files:

* `qmv` lets you quickly move large numbers of files using a text editor. I use it all the time.
* `imv` lets you rename a file by editing its name using `readline`
* `qcp` and `icp` are like `qmv` and `imv`, but let you copy files instead of moving them
* `deurlname` renames a file, replacing URL-encoded characters (like `%20`) with their plain-text equivalent.

This one looked like it'd be simple enough - the instructions were to just run `./configure`, `make`, then `make install`. Unfortunately, due to a typo in the Makefile, the `make install` failed. I figured I could look into the way it was built for established distros, so on my host system, I ran `apt source renameutils` to download the source that the Pop!_OS build is made from, and found 2 patches - `install-exec-local-fix.patch` and `typo_fix.patch`. Applying those patches in that order right after extracting the `renameutils` source archive fixed it.

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

### libevent 2.1.12

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

### tmux 3.3a

A **t**erminal **mul**tiplexer with an uncreative name. Used as a back-end by `byobu` - a "terminal window manager" I often use when multitasking.

```sh
wget https://github.com/tmux/tmux/releases/download/3.3a/tmux-3.3a.tar.gz
tar xf tmux-3.3a.tar.gz
cd tmux-3.3a
./configure --prefix=/usr --sysconfdir=/etc --docdir=/usr/share/doc/tmux-3.3a
make
sudo make install
```

### byobu 5.133

A "terminal window manager" that I like to use for multitasking. Uses either GNU `screen` or `tmux` as a back-end. The `byobu-config` script has runtime dependency on snack, a part of the newt package, which depends on popt and s-lang. S-lang (a.k.a. slang) has optional dependencies on PCRE, libpng, oniguruma, and zlib. Zlib is part of the base LFS system, and PCRE, popt, and libpng are in BLFS, though I did not notice popt was present until after I'd already installed it myself. Once the dependencies covered in B/LFS are built, you can run the following to build byobu and its runtime dependencies.

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

### Nerd Fonts v2.2.2

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

### lshw B.02.19.2

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

### bat 0.22.1

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

### hexyl 0.12.0

A hex-dump utility with colors and fancy output

```sh
wget https://github.com/sharkdp/hexyl/archive/refs/tags/v0.12.0.tar.gz -O hexyl-0.12.0.tar.gz
tar xf hexyl-0.12.0.tar.gz
cd hexyl-0.12.0
cargo build --release --bins --locked
sudo strip target/release/hexyl -o /usr/bin/hexyl
```

### fd 8.6.0

An alternative to `find` that's easier to use and has saner defaults

```sh
wget https://github.com/sharkdp/fd/archive/refs/tags/v8.6.0.tar.gz -O fd-8.6.0.tar.gz
tar xf fd-8.6.0.tar.gz
cd fd-8.6.0
cargo build --release --bins --locked
sudo strip target/release/fd -o /usr/bin/fd
sudo cp doc/fd.1 /usr/share/man/man1
```

### Hed [Commit 44d3eb7]

A simple vi-like hex editor with minimal dependencies

This one's designed to install from the `master` branch.

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
tar --exclude-vcs --exclude-vcs-ignores -cJvf hed-44d3eb7.tar.xz hed-44d3eb7
```

### Xorg Drivers and Guest utilities

This section contains Xorg drivers not from B/LFS, as well as assorted tools to allow for better performance of the LFS system, and better interaction with the host system.

Finding out what Xorg drivers to build, and how to build them, was a pain. I was able to find some work-in-progress BLFS pages [here](https://wiki.linuxfromscratch.org/blfs/wiki/qemu), but they were out of date, and the build process for spice-protocols had been changed.

#### spice-protocol

```sh
wget https://gitlab.freedesktop.org/spice/spice-protocol/-/archive/v0.14.4/spice-protocol-v0.14.4.tar.bz2
tar xf spice-protocol-v0.14.4.tar.bz2
cd spice-protocol-v0.14.4
mkdir build && cd build
meson -Dlibdir=/usr/lib -Dbackend=ninja -Dstrip=true -Ddebug=false --buildtype=release --prefix=/usr ..
sudo ninja install
```

#### usbredir

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

#### SPICE (Server) + Dependencies

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

#### xf86-video-qxl + xspice

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

#### spice-vdagent

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

#### x-resize

A simple shell script which, when set up with a udev rule and proper drivers, can automatically resize the screen to fit the size of the window on the host system.
Based on [this Github Gist](https://gist.github.com/3lpsy/4cc344ae031bf77595991c536cbd3275), with paths modified to be better integrated into the LFS environment, and the ability to respond to events involving cards other than `/dev/dri/card0` - specifically, it matches `card?`, where `?` is any single character.

Depends on udev (part of systemd) and xspice.

```sh
wget https://gist.githubusercontent.com/eliminmax/f2eff01a304607b4249cbc4f027cbd91/raw/43296df8c17aa45c1f9772746e911be66a99feb7/x-resize-LFS -O x-resize
sudo install -m744 x-resize /usr/sbin
sudo dd of=/usr/lib/udev/rules.d/50-x-resize.rules <<EOF
ACTION=="change",KERNEL=="card?", SUBSYSTEM=="drm", RUN+="/usr/sbin/x-resize"
EOF
sudo udevadm control --reload-rules
```

### Neovim-8.1

By default, Neovim's makefile downloads 3rd-party dependencies and statically links them. I originally was planning on dynamically linking all of them, but that proved to be a bit too painful. I'm never going to use them for anything other than neovim, so there's not much reason to try to force it. The only ones I'm going to configure it to dynamically link against are libuv, which is included in BLFS, and gettext, which is part of LFS. The build instructions for Neovim explicitly recommend using `ninja` to build it, but I found it hard to get `ninja install` to install it to the `/usr` prefix instead of the `/usr/local` prefix, so I didn't do that.

Assuming that you've built libuv from BLFS, you can build Neovim as follows:

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

I was originally planning on replacing vim 9 with neovim, but I decided not to - they each have some things that they do better than the other.

### the silver searcher (ag)

A tool to rapidly search through a directory tree for regex matches. Much faster than `grep --recursive`. Installed from git repository, commit `a61f178`.

Has 4 dependencies: Automake, pkg-config, liblzma, and PCRE. The first three are part of the base LFS system, and PCRE is part of BLFS, and was already installed for other software that depends on it.


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

### Git 2.39.0 Bash Completion

The source tarball for git contains bash, zsh, and tcsh completion scripts, which were not installed alongside git.

Because I don't plan on installing zsh or tcsh, I am only installing the bash completion script

```sh
# extract only the needed file
tar xf git-2.39.0.tar.xz git-2.39.0/contrib/completion/git-completion.bash --strip-components=3
sudo install -m644 -C -o root -g root git-completion.bash /usr/share/bash-completion/completions/git
rm git-completion.bash
```

### Whisker Menu

A plugin for Xfce4 that adds a more advanced app menu

```sh
wget https://archive.xfce.org/src/panel-plugins/xfce4-whiskermenu-plugin/2.7/xfce4-whiskermenu-plugin-2.7.1.tar.bz2

tar xf xfce4-whiskermenu-plugin.2.7.1.tar.bz2
cd xfce4-whiskermenu-plugin.2.7.1
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=/usr/lib -DCMAKE_INSTALL_LOCALEDIR=/usr/share/locale -DCMAKE_INSTALL_MANDIR=/usr/share/man ..
make
sudo make install
```

### Papirus icon theme 20221201

An icon theme I'm rather fond of

```sh
wget https://github.com/PapirusDevelopmentTeam/papirus-icon-theme/archive/refs/tags/20221201.tar.gz -O - | gzip -d | xz > papirus-icon-theme-20221201.tar.xz
tar xf papirus-icon-theme-20221201.tar.xz
cd papirus-icon-theme-20221201
sudo make install
```

### kitty-0.26.5

An extensible, fast, high-performance GPU-accelerated terminal emulator, with support for python plugins known as "kittens"

Build Dependencies:
* gcc or clang (part of base LFS system)
* pkg-config (part of base LFS system)
* libdbus-1 (part of base LFS system)
* libxcursor (part of BLFS Xorg Libraries)
* libxrandr (part of BLFS Xorg Libraries)
* libxi (part of BLFS Xorg Libraries)
* libgl1-mesa (part of BLFS Mesa)
* libxkbcommon-x11 (part of BLFS libxkbcommon)
* libfontconfig (part of BLFS Fontconfig)
* libx11-xcb (not sure where I got this, but it's installed)
* libpython3 (part of base LFS system)
* liblcms2 (Little CMS 2.13.1 in BLFS)
* librsync
  * depends on popt, which I'd installed from outside of BLFS, but is available in BLFS

Runtime Dependencies:

* python 3 (part of the base LFS system)
* harfbuzz (included in BLFS)
* zlib (part of the base LFS system)
* libpng (included in BLFS)
* liblcms2 (included in BLFS)
* freetype (included in BLFS)
* fontconfig (included in BLFS)
* libcanberra (included in BLFS)
* ImageMagick (included in BLFS)
* pygments (part of BLFS Python Modules)
* openssl (part of the base LFS system)
* librsync

I had already installed all of the B/LFS-provided dependencies except for ImageMagick and Little CMS 2. I built Little CMS 2 without issue.

Building librsync (which is not actually part of rsync) can be done as follows:
```sh
wget https://github.com/librsync/librsync/releases/download/v2.3.2/librsync-2.3.2.tar.gz
gunzip librsync-2.3.2.tar.gz
tar xf librsync-2.3.2.tar
xz libsync-2.3.2.tar
cd librsync-2.3.2
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=/usr/lib -DCMAKE_INSTALL_LOCALEDIR=/usr/share/locale -DCMAKE_INSTALL_MANDIR=/usr/share/man .
make
sudo make install
```

Kitty has its own way of doing things. To build it, you can run the following, but it installs it to the linux-package directory within the source tree by default.
```sh
wget https://github.com/kovidgoyal/kitty/releases/download/v0.26.5/kitty-0.26.5.tar.xz
tar xf kitty-0.26.5.tar.xz
cd kitty-0.26.5
make linux-package
```

To move the installation into the /usr prefix, you can do the following:

```sh
cd linux-package
tar cf _installation.tar bin lib share
sudo tar xf _installation.tar -C /usr --owner=root --group=root
```

There are probably more "correct" ways to do that, but it works.

### BPython

A REPL (Read Evaluate Print Loop) for python, with syntax highlighting, written in python.

Installation:

```sh
wget https://files.pythonhosted.org/packages/79/71/10573e8d9e1f947e330bdd77724750163dbd80245840f7e852c9fec493c4/bpython-0.23.tar.gz
tar xf bpython-0.23.tar.gz
cd bpython-0.23
pip3 wheel -w dist --no-build-isolation --no-deps $PWD
pip3 install --no-index --find-links dist --no-cache-dir bpython
```

### pfetch-0.6.0

A system info display tool, written fo POSIX-compliant shells.

Made by the same person as Neofetch. Output is much smaller, making it good as a pseuto-MOTD.

Installation:

```sh
wget https://github.com/dylanaraps/pfetch/archive/refs/tags/0.6.0.tar.gz -O pfetch-0.6.0.tar.gz
tar xf pfetch-0.6.0.tar.gz pfetch-0.6.0/pfetch --strip-components=1
sudo cp pfetch /usr/bin
```

### LightDM GTK+ Greeter Settings

A graphical settings app, which integrates with the XFCE4 settings manager, and manages the LightDM GTK+ greeter.

Dependencies:
* Python3 GOBject-Introspection bindings (BLFS Python Modules PyGObject-3.42.2)
* lightdm-gtk-greeter (BLFS lightdm-1.32.0)
* gdk-pixbuf (BLFS gdk-pixbuf-2.42.9)
* GTK3+ (BLFS GTK+-3.24.34)
* Pango (BLFS Pango-1.50.0)
* Polkit (BLFS Polkit-121, updated on my system to Polkit-122)
* python-distutils-extra (not part of B/LFS)
  * intltool (not part of B/LFS)

I did not list dependencies that are part of the base LFS system.

Of those, I had to build the Python3 GOBject-Introspection bindings and python-distutils-extra along with intltool. I build the former using the BLFS instructions, and the latter two, along with the package itself, as follows:

```sh
wget https://launchpad.net/intltool/trunk/0.51.0/+download/intltool-0.51.0.tar.gz
wget https://deb.debian.org/debian/pool/main/p/python-distutils-extra/python-distutils-extra_2.47.tar.xz
wget https://github.com/Xubuntu/lightdm-gtk-greeter-settings/releases/download/lightdm-gtk-greeter-settings-1.2.2/lightdm-gtk-greeter-settings-1.2.2.tar.gz

tar xf intltool-0.51.0.tar.gz
pushd intltool-0.51.0
./configure --prefix=/usr
make
sudo make install
popd

tar xf python-distutils-extra_2.47.tar.xz
pushd python-distutils-extra_2.47
pip3 wheel -w dist --no-build-isolation --no-deps $PWD
sudo pip3 install --no-index --find-links dist --no-cache-dir python-distutils-extra
popd

tar xf lightdm-gtk-greeter-settings-1.2.2.tar.gz
cd lightdm-gtk-greeter-settings-1.2.2
pip3 wheel -w dist --no-build-isolation --no-deps $PWD
sudo python3 setup.py install --optimize=1 --xfce-integration
```

I originally installed it with `sudo pip3 install --no-index --find-links dist --no-cache-dir lightdm-gtk-greeter-settings`, but that resulted in a broken installation.


### Materia Compact GTK Theme

A clean, no-nonsense GTK 2, 3, and 4 theme that follows the principles of material design. Comes in standard and compact versions, and 3 color variations. I like to use the compact dark version almost exclusively, but I'd like to keep another option open, so I'm building it with the default color scheme as well. Building it requires meson and sassc, both of which are in BLFS.

At runtime, it need gnome-themes-extra, which is included in BLFS, and the murrine GTK2 theme engine, which is not.

To install murrine and the Materia Compact and Compact Dark themes, run the following

```sh
wget https://download.gnome.org/sources/murrine/0.98/murrine-0.98.2.tar.xz
wget https://github.com/nana-4/materia-theme/archive/refs/tags/v20210322.tar.gz -O materia-theme-20210322.tar.gz

tar xf murrine-0.98.2.tar.xz
pushd murrine-0.98.2
./configure --disable-static --prefix=/usr --sysconfdir=/etc --localstatedir=/var --docdir=/usr/share/doc/murrine-0.98.2
make
sudo make install
popd

tar xf materia-theme-20210322.tar.gz
cd materia-theme-20210322
mkdir build
cd build
meson --prefix=/usr -Dsizes=compact -Dcolors=default,dark -Dlibdir=/usr/lib -Dbackend=ninja -Dstrip=true -Ddebug=false ..
ninja
sudo ninja install
```

# Software updates

## B/LFS

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
    * libxml2 (which I did not realize at the time)
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
* systemd-252 + [coredump patch](https://www.linuxfromscratch.org/patches/blfs/svn/systemd-252-security_fix-1.patch)
  * A vulnerability in systemd versions 246 and up was found that can be used to trigger information leaks and privilege escalation. The development version of B/LFS at time of writing (Version r11.2-692) provides a patch to fix it. A similar patch exists for systemd-251, but if I need to rebuild anyway, I figure I might as well upgrade.
* libtiff-4.5.0 *(Adapted from instructions written for version 4.4.0 in BLFS Systemd version r11.2-709)*
* curl-7.87.0 *(Adapted from instructions written for version 7.86.0 in BLFS Systemd version r11.2-709)*
* GLib-2.74.3 *(Adapted from instructions written for version 2.74.3 in BLFS Systemd version r11.2-709)*
* xorg-server-21.1.6 *(already built this version, but rebuilt with Xephyr after installing its dependencies)*

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

## Updates on the evening of Friday December 30th 2022 EST

The web page of [LFS and BLFS Security Advisories from September 2020 onwards](https://www.linuxfromscratch.org/blfs/advisories/consolidated.html) was updated to include 3 new listed items, but the BLFS development snapshot available at the time (r11.2-709) still has vulnerable versions.

I built the newer versions with the instructions for the previous versions, with the following differences:

* Replaced the version numbers in download urls, file paths, `./configure --docdir=` arguments, etc.
* Passed `-DCMAKE_INSTALL_LIBDIR=/usr/lib` to the libtiff `cmake` command, so that it would install to `/usr/lib`, rather than `/usr/lib64`.
* Skipped required libtiff patch, as it fixes vulnerabilities in version 4.4.0 that were patched in 4.5.0 anyway
* Skipped optional GLib patch, as it's optional, and not yet available for 2.74.4

## Broken Polkit Authorization

The **/etc/pam.d/polkit-1** file was misconfigured in a way that prevented proper authorization with `pkexec`.

It should have looked like the following:

```pamconf
#%PAM-1.0

auth       include      system-auth
account    include      system-account
password   include      system-password
session    include      system-session
```

Instead, it had the following:

```pamconf
#%PAM-1.0

auth       include      system-auth
account    include      system-auth
password   include      system-auth
session    include      system-auth
```

This caused the LightDM GTK+ Greeter settings app to fail to launch, because it uses `pkexec` to get necessary authorization to modify the LightDM settings.

I assume that what happened was that I'd made the file by hand, rather than pasting its contents in straight from the BLFS book, and wasn't paying proper attention. Once I found it, it was an easy fix.

## Failure to start systemd-oomd

The `systemd-oomd` service failed to start, with the following error:

```
Dec 31 12:56:44 array-lfs systemd[1]: Userspace Out-Of-Memory (OOM) Killer was skipped because of an unmet condition check (ConditionPathExists=/proc/pressure/memory).
```

A bit of research indicated that the `/proc/pressure` directory is provided by kernels built with `CONFIG_PSI=y`. My current kernel, at time of writing, is built from the config at [kernel-configs/config-6.1.1-lfs-11.2-systemd-eliminmax-0](./kernel-configs/config-6.1.1-lfs-11.2-systemd-eliminmax-0).

If you look at line 140 of that config, it reads.
```
# CONFIG_PSI is not set
```

I am in the process of building a new kernel, with the following changes applied to the config.

```diff
31c31
< CONFIG_LOCALVERSION="eliminmax-0"
---
> CONFIG_LOCALVERSION="eliminmax-1"
140c140,141
< # CONFIG_PSI is not set
---
> CONFIG_PSI=y
> # CONFIG_PSI_DEFAULT_DISABLED is not set
```
