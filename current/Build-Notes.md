# Introduction

<!-- vim-markdown-toc GFM -->

* [Bootstrapping](#bootstrapping)
  * [Configuration of bootstrap system](#configuration-of-bootstrap-system)
  * [Partitioning](#partitioning)
* [Points of deviation](#points-of-deviation)
  * [BTRFS](#btrfs)
  * [Clear](#clear)
  * [No Root login](#no-root-login)
  * [Temporary Editor](#temporary-editor)
  * [Bash-Completion](#bash-completion)
  * [Errata and Security Advisories](#errata-and-security-advisories)
* [Post-LFS](#post-lfs)
  * [BLFS](#blfs)
  * [Non-B/LFS](#non-blfs)
* [Problems Encountered and Troubleshooting](#problems-encountered-and-troubleshooting)
  * [Problems with LFS Software](#problems-with-lfs-software)
    * [GCC and /usr/lib64](#gcc-and-usrlib64)
    * [Grub and BTRFS](#grub-and-btrfs)
  * [Problems with BLFS Software](#problems-with-blfs-software)
    * [make-ca](#make-ca)
  * [Problems with Non-B/LFS Software](#problems-with-non-blfs-software)
    * [Bash-Completion sysconfdir](#bash-completion-sysconfdir)

<!-- vim-markdown-toc -->

I used Linux From Scratch Version 12.0 as a basis for my build, and will note any deviation from its instructions, as well as any difficulties faced while working on it.

## Bootstrapping

### Configuration of bootstrap system

I created a file at `/etc/profile.d/Z99-LFS.sh` to set the `LFS` variable, and a file at `/etc/sudoers.d/lfs` to ensure that it was preserved.

The contents of `/etc/profile.d/Z99-LFS.sh` are as follows:

```sh
export LFS=/mnt/lfs
```

The contents of `/etc/sudoers.d/lfs` are as follows
```sudoers
Defaults env_keep += LFS
```

Like my previous build, I used the `eliminmax` user instead of a dedicated `lfs` user, and, despite what the instructions said, did not move the existing `/etc/bashrc` file. Nothing in that file should impact the build process.

My `~/.bash_profile` file is different from the one in the instructions, with the following contents:

```bash
[ -f ~/.bashrc ] && . ~/.bashrc
```

My `~/.bashrc` file, in turn, is as follows:

```bash
if [ ! "$BASHRC_SOURCED" = 'true' ]; then
    [ -e /etc/bashrc ] && . /etc/bashrc
    set +h
    umask 022

    if [ -e /etc/profile.d/Z99-LFS.sh ] ; then
        . /etc/profile.d/Z99-LFS.sh
    else
        export LFS="${LFS:-/mnt/LFS}"
    fi

    export LC_ALL=POSIX
    export LFS_TGT="$(uname -m)-lfs-linux-gnu"
    export PATH="$LFS/tools/bin:/usr/local/bin:/usr/bin:/opt/rustc/bin"
    export CONFIG_SITE="$LFS/usr/share/config.site"

    BASHRC_SOURCED=true
fi
```

The other relevant system configuration files are in the `LFS_11.2_systemd/etc/` directory of this repository.

### Partitioning

I used a GUID partition table (GPT), with 3 partitions, set up with `cfdisk`. The first was a 1 megabyte partition, to install GRUB to, then a 60G filesystem partition, and a 4G swap partition.

I formatted the filesystem partition with BTRFS, and created 4 subvolumes: `@rootfs` (which I set as the default), `@home`, `@sources`, and `@boot`. I added entries to the host system's `/etc/fstab` file to automatically mount them.

To create those subvolumes, first mount the partition to `/mnt/lfs`, then run the following as root:

```sh
btrfs subvolume create /mnt/lfs/@rootfs
btrfs subvolume set-default /mnt/lfs/@rootfs
btrfs subvolume create /mnt/lfs/@home
btrfs subvolume create /mnt/lfs/@sources
btrfs subvolume create /mnt/lfs/@boot
```

## Points of deviation

### BTRFS

The first point of deviation is that I am installing to a B-tree filesystem (btrfs) instead of the ext4 filesystem that LFS assumes, so before creating a file system on the bootstrap system, I needed to build the `btrfs-progs` software package. Because I was bootstrapping from my previous B/LFS system, originally based on version 11.2-systemd, I used the 11.2-systemd build instructions (available [here](https://www.linuxfromscratch.org/blfs/view/11.2-systemd/postlfs/btrfs-progs.html)). While I had installed the recommended dependencies, I skipped generating the documentation.

The first knock-on effect this caused was almost immediate, as the `mkfs` command was different - instead of `mkfs -v -t ext4 /dev/vdb2`, I ran `mkfs.btrfs -v /dev/vdb2`. I initially tried to run `mkfs -v -t btrfs /dev/vdb2`, but that did not work, as the `mkfs` command did not recognize `btrfs` as a file system type.

I did not initially create the `@sources` subvolume, and had some difficulty figuring out how to create it outside of the `@rootfs` subvolume.

What I had to do was unmount the BTRFS filesystem, and remount with the option `subvolid=0`, then create it.

At the end of chapter 7, instead of creating a tarball of the system, I took a snapshot of the `@rootfs` subvolume.

At the end of chapter 8, as the `eliminmax` user, I built [btrfs-progs-6.3.3](https://linuxfromscratch.org/blfs/view/12.0/postlfs/btrfs-progs.html) from BLFS (first building its required dependency, [LZO-2.10](https://linuxfromscratch.org/blfs/view/12.0/general/lzo.html), also from BTRFS). After building and installing it, I installed the bash completion for the `btrfs` command by running `sudo install -m644 btrfs-completion /usr/share/bash-completion/completions/btrfs` from the `btrfs-progs` source directory.

I anticipated that this would cause me some trouble with configuring GRUB, and [it did](#grub-and-btrfs). That was, at least in part, my motivation for using BTRFS - if everything could be done by the book, and I'd done it about a year ago already, there's nothing to gain from just going by the book again (though I did deviate last time, disabling root login and installing `sudo` instead).

### Clear

Instead of using the Ncurses `clear` binary, I used the [tiny-clear-elf](https://github.com/eliminmax/tiny-clear-elf) binary for the `amd64` architecture during the first build of Ncurses. During the second build, I passed an extra configure flag: `--program-transform-name='s/clear/clear.ncurses/'`. This installed the ncurses `clear` binary with the name `clear.ncurses` instead of `clear`, so that it would not overwrite the tiny-clear-elf `clear` command.

### No Root login

Instead of setting up a root password in 8.26.3, I created a new `eliminmax` user and granted that user passwordless sudo permissions, and disabled root login. Of course, this required `sudo` to be installed, so I built it using the instructions from BLFS 12.0, adding the following line to the end of `/etc/sudoers.d/00-sudo`:

```sudoers
eliminmax ALL=(ALL:ALL) NOPASSWD: ALL
```

### Temporary Editor

While waiting for the chapter 8 GCC build, I copied a statically-linked build of BusyBox vi to the path `/opt/tmp_tools/bbvi` and started setting the `EDITOR` environment variable to that path within the LFS chroot, in case I needed an editor for anything. I deleted it and stopped setting the `EDITOR` variable after building vim.

### Bash-Completion

Immediately after installing the final build of GCC, I installed the bash-completion-2.11 package, using the process I documented [here](./Non-LFS-Software/bash-completion.md).

### Errata and Security Advisories

Following an errata, instead of Python 3.11.4, I downloaded 3.11.5.

Following [LFS security advisory 12.0 005](https://www.linuxfromscratch.org/blfs/advisories/consolidated.html#sa-12.0-005), instead of the memalign patch for Glibc, I used the new [glibc-2.38-upstream-fixes-2](https://www.linuxfromscratch.org/patches/downloads/glibc/glibc-2.38-upstream_fixes-2.patch), which fixes additional vulnerabilities that do not affect the default LFS configuration. I figured that I might as well fix it even if it's unlikely to affect me.

I then rebuilt it again before chapter 8.30, to fix that and a far more serious privilege escalation vulnerability, as instructed in [LFS security advisory 12.0 018](https://www.linuxfromscratch.org/blfs/advisories/consolidated.html#sa-12.0-018).

Following the advice in chapter 8.47, and seeing that there was a new release of OpenSSL providing a fix for a security issue, instead of building OpenSSL version 3.1.2, I built 3.1.3. After looking into it, however, I learned that the vulnerability was Windows-specific, so it was unnecessary, but not harmful.

## Post-LFS

This is a list of programs I built after completing the initial LFS build.

### BLFS

In addition to Sudo and BTRFS-Progs, I built the following software from BLFS, as well as all dependencies listed as either required and reccommended on the BLFS page, unless otherwise noted.

* [Wget-1.21.4](https://linuxfromscratch.org/blfs/view/12.0/basicnet/wget.html)
* [OpenSSH-9.4p1](https://linuxfromscratch.org/blfs/view/12.0/postlfs/openssh.html)
  * later updated to version 9.6p1 to address the Terrapin vulnerability, using the [BLFS instructions for version 9.5p1](https://linuxfromscratch.org/blfs/view/svn/postlfs/openssh.html) and changing the number where applicable.
* [Which-2.21](https://linuxfromscratch.org/blfs/view/12.0/general/which.html)
  * *note: I installed the actual GNU which, not the shell script alternative*
* [cURL-8.4.0](https://linuxfromscratch.org/blfs/view/svn/basicnet/curl.html)
  * built with optional build dependency nghttp2-1.58.0
  * both cURL and nghttp2 are newer versions due to security vulnerabilities found in the versions used in BLFS 12.0.
  * later updated to version 8.5.0 due to more security issues
* [extra-cmake-modules-5.109.0](https://linuxfromscratch.org/blfs/view/12.0/kde/extra-cmake-modules.html)
  * I was planning on going with KDE Plasma on Wayland, until I saw the number of dependencies I'd need to deal with, and decided against it for now. I also wanted to leave my comfort zone and go with something else - Hyprland. I built this before realizing how big of a task it would be, and didn't see any need to uninstall it.
* [Git-2.41.0](https://linuxfromscratch.org/blfs/view/12.0/general/git.html)
* [LLVM-16.0.5](https://linuxfromscratch.org/blfs/view/12.0/general/llvm.html)
* [libssh2-1.11.0](https://linuxfromscratch.org/blfs/view/12.0/general/libssh2.html)
  * Rebuilt with a patch to address the Terrapin vulnerability, available [here](https://www.linuxfromscratch.org/patches/blfs/svn/libssh2-1.11.0-security_fixes-1.patch) as of December 27th, 2023.
* [UnZip-6.0](https://linuxfromscratch.org/blfs/view/12.0/general/unzip.html)
* [Rustc-1.74.1](https://linuxfromscratch.org/blfs/view/12.0/general/rust.html)
  * Built a newer version, but used the BLFS instructions, replacing the version number whenever it appeared.
  * I had [an alternative file](./etc/profile.d/rustc.sh) `/etc/profile.d/rustc.sh` file that works with [my existing `/etc/profile` file](./etc/profile)

### Non-B/LFS

In addition to Bash-Completion and tiny-clear-elf, I built the following software from outside of LFS and BLFS, and documented the build process in the linked pages.

* [kitty-terminfo-0.30.1](./Non-LFS-Software/kitty-terminfo.md)
* [extra bash completion scripts](./Non-LFS-Software/extra-bash-completion.md)
* [Neovim-0.9.4](./Non-LFS-Software/neovim.md)
  * I replaced `vim` with Neovim entirely, only keeping `xxd`, which is not bundled with Neovim.
* [bat-0.24.0](./Non-LFS-Software/bat.md)

## Problems Encountered and Troubleshooting

### Problems with LFS Software

#### GCC and /usr/lib64

After building and installing Libffi (chapter 8.50), I realized that when building GCC in chapter 8.27 for the 3rd time (after 2 false starts), it had installed libraries to `/usr/lib64`. Libffi also installed its libraries to the wrong directory, and I had to restart chapter 8. I suppose I could have gone package by package, only rebuilding what but determining what I'd need to rebuild seemed to be too much effort.

Thankfully, I'd set up the system with 4 different BTRFS subvolumes, and had stored snapshots of the root subvolume at the end of chapter 7, so I was able to restore that. Unforunately, it happened again, two more times. On the fourth attempt, to save time, I skipped the test suite, and the problem did not reoccur. I don't know how the test suite could have had that impact, and it may be another factor, but I was able to proceed without issue.

#### Grub and BTRFS

Because the LFS instructions were written for an EXT4 filesystem, I could not use them as-is. It took some work to find a solution - most information I could find online assumes that you're using a distro-provided `grub` configuration tool and/or an initramfs. I was eventually able to figure it out, and created then used the following `grub.cfg` file template:

```cfg
set default=0
set timeout=5

insmod part_gpt
insmod btrfs


search --set=root --fs-uuid <UUID of BTRFS filesystem>

menuentry "<Menu Entry Name>"  {
	linux /@boot/<kernel name> root=PARTUUID=<PARTUUID of partition containing BTRFS filesystem> ro
}
```

### Problems with BLFS Software

#### make-ca

`make-ca-1.12`, a runtime dependency for Wget, comes with an outdated certificate, and cannot update to it, so I build `make-ca-1.13` to replace it, as instructed in the [BLFS 12.0 errata](https://www.linuxfromscratch.org/blfs/errata/12.0/).

This was complicated by the fact that I did not have a tool to download it in the LFS environment. I had the source code for `wget`, but, as mentioned, it has `make-ca` as a runtime dependency.

Thankfully, I also had the source code for BusyBox 1.36.1, which is a multi-tool of sorts, which comes with hundreds of smaller versions of common command-line tools bundled into a single executable, including `wget`. I build a version containing only `wget` and `nslookup`, and after building it, downloaded Make-CA 1.13 to my laptop from the link in the `make-ca-1.13` from `https://github.com/lfs-book/make-ca/releases/download/v1.13/make-ca-1.13.tar.xz`, and started a simple Python HTTP server on port 8000 from my downloads folder. I then ran `./busybox wget http://<local ip of laptop>:8000/make-ca-1.13.tar.xz`

### Problems with Non-B/LFS Software

#### Bash-Completion sysconfdir

When building it initially, I missed the `--sysconfdir=/etc` flag, so it installed with the sysconfdir set to `/usr/etc`. I discovered the problem after completing the initial LFS build. I then rebuilt it, adding that flag, and removed the `/usr/etc` directory
