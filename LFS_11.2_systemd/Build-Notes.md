# Introduction

I used Linux From Scratch Version 11.2-systemd as a basis for my build, and noted any deviation from its instructions, and difficulties I ran into while working on it.

The original notes, including extensive documentation about the system I used to bootstrap and build the system, is in the file **Original-Build-Notes.md**.

My final system included a few extra pieces of software: OpenSSH and Sudo from BLFS, and a few external programs: BASH completion, the Oil/Osh shell with a personal patch, and Neofetch, an eye-candy system info display tool written in bash.

Originally, this page was a Github Gist I'd edit as I was building the base LFS system, but it got so big that Neovim kept freezing while I was editing it. I split off the part containing the entire Kernel config, copied my notes from the point at which I successfully booted the LFS system, and later removed most of the original notes, because this document was starting to get a bit overwhelming, and the old version was already saved to the other file.

# Table of Contents
# Additional Software from BLFS
<!-- vim-markdown-toc GFM -->

  * [Notes on specific software](#notes-on-specific-software)
    * [Wget-1.21.3](#wget-1213)
    * [cURL-7.84.0](#curl-7840)
    * [Git-2.37.2](#git-2372)
    * [Linux-PAM-1.5.2](#linux-pam-152)
    * [Rustc-1.60.0](#rustc-1600)
    * [Polkit-121](#polkit-121)
    * [UPower-1.90.0](#upower-1900)
    * [Mesa](#mesa)
    * [libtiff-4.4.0](#libtiff-440)
    * [librsvg-2.54.4](#librsvg-2544)
    * [xdg-utils-1.1.3](#xdg-utils-113)
    * [Node.js-18.12.1](#nodejs-18121)
    * [Firefox-102.6.0esr](#firefox-10260esr)
    * [xorg-server 21.1.6](#xorg-server-2116)
    * [libtiff-4.5.0](#libtiff-450)
    * [slang-2.3.3](#slang-233)
    * [popt-1.18](#popt-118)
    * [newt-0.52.21](#newt-05221)
* [External software](#external-software)
  * [Installed external software](#installed-external-software)
* [Software updates](#software-updates)
  * [B/LFS](#blfs)
  * [Non-B/LFS](#non-blfs)
* [Miscellaneous Issues](#miscellaneous-issues)
  * [End of chapter 8 crisis](#end-of-chapter-8-crisis)
  * [Kernel config woes](#kernel-config-woes)
  * [SSH X forwarding](#ssh-x-forwarding)
  * [Kernel config woes (again)](#kernel-config-woes-again)
  * [Locale](#locale)
  * [Updates on the evening of Friday December 30th 2022 EST](#updates-on-the-evening-of-friday-december-30th-2022-est)
  * [Broken Polkit Authorization](#broken-polkit-authorization)
  * [Failure to start systemd-oomd](#failure-to-start-systemd-oomd)
  * [LightDM Login failure.](#lightdm-login-failure)
  * [byobu dependency tree](#byobu-dependency-tree)
  * [Mass man deletion](#mass-man-deletion)
  * [Lost snapshots](#lost-snapshots)
  * [Xfce 4.18 Upgrade](#xfce-418-upgrade)

<!-- vim-markdown-toc -->

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

### slang-2.3.3

Built with all 3 optional dependencies

### popt-1.18

Had previously built popt-1.19, so I uninstalled everything that linked against popt and rebuilt against the version from BLFS

### newt-0.52.21

Had previously built newt-r0-52-23, so I rebuilt everything that linked against this version.

Instead of passing `--with-python=python3.10`, I passed `--with-python=python3.11`, so that it build a python module for the right version.

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
tar cJvf libfoo-e1a6d82.tar.xz libfoo-e1a6d82 --exclude-vcs-ignores --exclude-vcs
rm -rf libfoo-e1a6d82
```

Patches, once used, should be compressed with xz. Copies of downloaded stand-alone scripts, like x-resize, should be kept in the `/sources` directory and xz-compressed.

Gzip'ed and Bzip2'ed tarballs should be decompressed and recompressed with xz.

## Installed external software

I documented the build and installation process for software I installed from outside B/LFS in the **Non-BLFS-Software directory**, and any non-B/LFS dependencies I built in the **Non-BLFS-Software/deps** directory.

List of installed external software:

* [ag](./Non-LFS-Software/ag.md)
* [bat](./Non-LFS-Software/bat.md)
* [bash-completion](./Non-LFS-Software/bash-completion.md)
* [bpython](./Non-LFS-Software/bpython.md)
* [byobu](./Non-LFS-Software/byobu.md)
* [extra-bash-completion](./Non-LFS-Software/extra-bash-completion.md)
* [fd](./Non-LFS-Software/fd.md)
* [hed](./Non-LFS-Software/hed.md)
* [hexyl](./Non-LFS-Software/hexyl.md)
* [jq](./Non-LFS-Software/jq.md)
* [kitty](./Non-LFS-Software/kitty.md)
* [lightdm-gtk-greeter-settings](./Non-LFS-Software/lightdm-gtk-greeter-settings.md)
* [lshw](./Non-LFS-Software/lshw.md)
* [materia-gtk-theme](./Non-LFS-Software/materia-gtk-theme.md)
* [neofetch](./Non-LFS-Software/neofetch.md)
* [neovim](./Non-LFS-Software/neovim.md)
* [nerd-fonts](./Non-LFS-Software/nerd-fonts.md)
* [oil](./Non-LFS-Software/oil.md)
* [papirus-icon-theme](./Non-LFS-Software/papirus-icon-theme.md)
* [pfetch](./Non-LFS-Software/pfetch.md)
* [renameutils](./Non-LFS-Software/renameutils.md)
* [usbredir](./Non-LFS-Software/usbredir.md)
* [xf86-video-qxl](./Non-LFS-Software/xf86-video-qxl.md)
* [xfce-panel-plugins](./Non-LFS-Software/xfce-panel-plugins.md)
* [x-resize](./Non-LFS-Software/x-resize.md)
* [zerofree](./Non-LFS-Software/zerofree.md)
* [sgt-puzzles](./Non-LFS-Software/sgt-puzzles.md)
* [xclip](./Non-LFS-Software/xclip.md)
* [xonsh](./Non-LFS-Software/xonsh.md)

List of installed external dependencies

* [intltool](./Non-LFS-Software/deps/intltool.md)
* [libevent](./Non-LFS-Software/deps/libevent.md)
* [librsync](./Non-LFS-Software/deps/librsync.md)
* [murrine](./Non-LFS-Software/deps/murrine.md)
* [onigumura](./Non-LFS-Software/deps/onigumura.md)
* [various python modules](./Non-LFS-Software/deps/python-modules.md)
* [qemu-guest-agent](./Non-LFS-Software/deps/qemu-guest-agent.md)
* [spice-protocol](./Non-LFS-Software/deps/spice-protocol.md)
* [spice-vdagent](./Non-LFS-Software/deps/spice-vdagent.md)
* [tmux](./Non-LFS-Software/deps/tmux.md)

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
* xfce4-4.18
  * I downloaded the source for the core components of the xfce4 desktop environment version 4.18, and built them in the same order I'd built their 4.16 equivalents.
    * [libxfce4util](https://archive.xfce.org/xfce/4.18/src/libxfce4util-4.18.0.tar.bz2)
    * [xfconf](https://archive.xfce.org/xfce/4.18/src/xfconf-4.18.0.tar.bz2)
    * [libxfce4ui](https://archive.xfce.org/xfce/4.18/src/libxfce4ui-4.18.0.tar.bz2)
    * [garcon](https://archive.xfce.org/xfce/4.18/src/garcon-4.18.0.tar.bz2)
    * [exo](https://archive.xfce.org/xfce/4.18/src/exo-4.18.0.tar.bz2)
    * [thunar](https://archive.xfce.org/xfce/4.18/src/thunar-4.18.0.tar.bz2)
    * [thunar-volman](https://archive.xfce.org/xfce/4.18/src/thunar-volman-4.18.0.tar.bz2)
    * [tumbler](https://archive.xfce.org/xfce/4.18/src/tumbler-4.18.0.tar.bz2)
    * [xfce4-appfinder](https://archive.xfce.org/xfce/4.18/src/xfce4-appfinder-4.18.0.tar.bz2)
    * [xfce4-panel](https://archive.xfce.org/xfce/4.18/src/xfce4-panel-4.18.0.tar.bz2)
    * [xfce4-power-manager](https://archive.xfce.org/xfce/4.18/src/xfce4-power-manager-4.18.0.tar.bz2)
    * [xfce4-settings](https://archive.xfce.org/xfce/4.18/src/xfce4-settings-4.18.0.tar.bz2)
    * [xfdesktop](https://archive.xfce.org/xfce/4.18/src/xfdesktop-4.18.0.tar.bz2)
    * [xfwm4](https://archive.xfce.org/xfce/4.18/src/xfwm4-4.18.0.tar.bz2)
    * [xfce4-session](https://archive.xfce.org/xfce/4.18/src/xfce4-session-4.18.0.tar.bz2)

## Non-B/LFS

I replaced Vim-9.0.0228 from B/LFS with Neovim-8.1, which I then upgraded to Neovim-8.2

# Miscellaneous Issues

The first two entries of this are from my original build notes, but after that, I've added a few new ones.

## End of chapter 8 crisis

At the end of chapter 8, in **8.79. Stripping**, I blindly copied in the commands that it listed, and that turned out to be a major problem, because I updated zlib to version 1.2.13, and it was set up to skip stripping a list of hard-coded libraries, which was still on 1.2.12. The `strip` binary depends on zlib, and somehow, when trying to strip its own dependency, `/usr/lib/libz.so.1.2.13` was overwritten, and was now an empty file. I had deleted the old zlib build directory, and had to restart from step one, but the `./configure` command failed without zlib already available. What I wound up doing was leaving the chroot environment, copying `/usr/lib/libz.so.1.2.11` from the build VM to the chroot, pointing the `/usr/lib/libz.so` and `/usr/lib/libz.so.1` symlinks to that, and rebuilding zlib, reverting the symlinks, rebuilding it yet again, then confirming that the one build with zlib 1.2.11 and the one build with zlib 1.2.13 were byte-for-byte identical.

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

* Replaced the version numbers in download URLs, file paths, `./configure --docdir=` arguments, etc.
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

A bit of research indicated that the `/proc/pressure` directory is provided by kernels built with `CONFIG_PSI=y`. My kernel at the time was built from [config-6.1.1-…-eliminmax-0](./kernel-configs/config-6.1.1-lfs-11.2-systemd-eliminmax-0).

If you look at line 140 of that config, it reads as follows:
```
# CONFIG_PSI is not set
```

I fixed it by switching to a new kernel, with the following changes applied to the config:

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

## LightDM Login failure.

Attempting to log into Xfce4 with LightDM resulted in the message **`Unable to Contact Settings Server`**. It turns out that I'd missed the fact that I needed to rebuild D-Bus after the Xorg Libraries were installed to get that working.

I owe my thanks to users audiodef and netfab on the gentoo discussion forums, because [this thread of theirs from 2020](https://forums.gentoo.org/viewtopic-t-1125607-start-0.html) pointed me right to the source of the problem.

## byobu dependency tree

When working through byobu's dependency tree, I did not notice that several of the dependencies were covered within BLFS. I rebuilt those depednencies as  covered in B/LFS, and rebuilt anything I'd previously built against newer versions of the software - I'd rather stick to the versions in B/LFS unless there's a reason not to (such as a security vulnerability).

## Mass man deletion

I deleted all of the man pages on the system, except for those provided by rust. I was trying to delete the pages in languages I don't speak, but messed up the glob, and ran `sudo rm -rf [a-n]* [o-z]*` without paying attention. That wiped out all man pages - I'd meant to exclude directories starting with "m", but I was tired.

In order to fix this, went through every source tarball on the system, and if it provides man pages, I installed them.

I'd tried to restore backups, but that did not work - see the next section.

## Lost snapshots

I had periodically been using what amounts to `virt-sparsify --compress foo.qcow2 foo__.qcow2 && mv foo__.qcow2 foo.qcow2` to reclaim space from my virtual hard drives, not realizing that doing so made all of my VM snapshots unusable.

## Xfce 4.18 Upgrade

I was a bit paranoid about upgrading the Xfce4 version in-place, so I rebuilt it in an environment that I created with some unholy amalgamation of mount namespaces, an overlayfs, and a chroot, after taking a snapshot of the system before I updated. As a result, I got a directory containing only files that were updated throughout. I then made a tarball of that, which I then extracted into the root directory. Naturally, that broke the running lightdm system, but after a reboot, it seemed to be working fine.

Not satisfied with that, I wrote then ran the following script to do it all over again in a more proper manner:

```sh
#!/bin/bash

set -ex

for pkg in {libxfce4util,xfconf,libxfce4ui,garcon,exo,thunar{,-volman},tumbler,xfce4-{appfinder,panel,power-manager,settings},xfdesktop,xfwm4,xfce4-session}-4.18.0; do
	wget "https://archive.xfce.org/xfce/4.18/src/$pkg.tar.bz2"
	bunzip2 "$pkg.tar.bz2"
	tar xf "$pkg.tar"
	pushd "$pkg"
	./configure $XORG_CONFIG
	make
	sudo make install
	popd
	rm -rf "$pkg"
	xz "$pkg.tar"
	mv "$pkg.tar.xz" /sources
done
```

What that does is iterate through the various components, downloads the source tarball, then decompress, extract, configure, build, and install the package. After that, it deletes the source directory, recompresses the tarball with `xz`, and moves the recompressed version to the **/sources** directory.

The `{libxfce4util,…xfwm4,xfce4-session}-4.18.0` thing is expanded to the following by `bash`:
```
libxfce4util-4.18.0 xfconf-4.18.0 libxfce4ui-4.18.0 garcon-4.18.0 exo-4.18.0 thunar-4.18.0 thunar-volman-4.18.0 tumbler-4.18.0 xfce4-appfinder-4.18.0 xfce4-panel-4.18.0 xfce4-power-manager-4.18.0 xfce4-settings-4.18.0 xfdesktop-4.18.0 xfwm4-4.18.0 xfce4-session-4.18.0
```
