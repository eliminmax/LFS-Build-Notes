# LFS Build Notes

<!-- vim-markdown-toc GFM -->

* [Bootstrap Systems](#bootstrap-systems)
  * [lfs-builder (2022)](#lfs-builder-2022)
  * [array-lfs (2023)](#array-lfs-2023)

<!-- vim-markdown-toc -->

I originally started work on an LFS system in October 2022, and continued working on updating it and adding additional software through early January 2023. After that, I archived it until September, when I decided to use my old LFS-based system to bootstrap a new one. My notes from that have been preserved in the **LFS_11.2_systemd/** directory, and in the git commit tagged `LFS_11.2_systemd`.

The current build is always in the `current` directory when it's an active project. Once I start a new project, I'll rename the existing `current` directory to the LFS version it is based on.

I intend to make this a roughly annual project, where each Fall through Winter, I use the previous year's LFS build to bootstrap the next year's build, and make each year's build substantially different in some way.

## Bootstrap Systems

This is a list of systems used to bootstrap each year's build, their specs (as reported by `neofetch`, and other assorted information.

### lfs-builder (2022)

A Debian Bullseye system, running on a VM, on a host laptop that has since broken down.

The first system I used to bootstrap an LFS system.

```
lfs-builder
---------------------
OS: Debian GNU/Linux 11 (bullseye) x86_64
Host: KVM/QEMU (Standard PC (Q35 + ICH9, 2009) pc-q35-7.0)
Kernel: 5.10.0-18-amd64
Shell: bash 5.1.4
CPU: Intel i7-10870H (12) @ 2.208GHz
GPU: 00:01.0 Red Hat, Inc. Virtio GPU
Memory: 24047MiB
```

**version-check.sh output** (from the **LFS 11.2-systemd** `version-check.sh`)

```
bash, version 5.1.4(1)-release
/bin/sh -> /usr/bin/bash
Binutils: (GNU Binutils for Debian) 2.35.2
bison (GNU Bison) 3.7.5
/usr/bin/yacc -> /usr/bin/bison.yacc
Coreutils:  8.32
diff (GNU diffutils) 3.7
find (GNU findutils) 4.8.0
GNU Awk 5.1.0, API: 3.0 (GNU MPFR 4.1.0, GNU MP 6.2.1)
/usr/bin/awk -> /usr/bin/gawk
gcc (Debian 10.2.1-6) 10.2.1 20210110
g++ (Debian 10.2.1-6) 10.2.1 20210110
grep (GNU grep) 3.6
gzip 1.10
Linux version 5.10.0-18-amd64 (debian-kernel@lists.debian.org) (gcc-10 (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2) #1 SMP Debian 5.10.140-1 (2022-09-02)
m4 (GNU M4) 1.4.18
GNU Make 4.3
GNU patch 2.7.6
Perl version='5.32.1';
Python 3.9.2
sed (GNU sed) 4.7
tar (GNU tar) 1.34
texi2any (GNU texinfo) 6.7
xz (XZ Utils) 5.2.5
g++ compilation OK
```

### array-lfs (2023)

I copied the disk image from the final version of my previous LFS build (from October 2022 through January 2023) and imported it into a new VM on a new host system.

```
eliminmax@array-lfs 
------------------- 
OS: Linux From Scratch x86_64 
Host: KVM/QEMU (Standard PC (Q35 + ICH9, 2009) pc-q35-7.2) 
Kernel: 6.1.1eliminmax-1 
Uptime: 24 secs 
Shell: bash 5.1.16 
Resolution: 1280x800 
CPU: Intel i7-8550U (2) @ 1.991GHz 
GPU: 00:01.0 Red Hat, Inc. Virtio 1.0 GPU 
Memory: 75MiB / 3928MiB 
```

**version-check.sh output** (from the **LFS 12.0** `version-check.sh`)

```
OK:    Coreutils 9.1    >= 7.0
OK:    Bash      5.1.16 >= 3.2
OK:    Binutils  2.39   >= 2.13.1
OK:    Bison     3.8.2  >= 2.7
OK:    Diffutils 3.8    >= 2.8.1
OK:    Findutils 4.9.0  >= 4.2.31
OK:    Gawk      5.1.1  >= 4.0.1
OK:    GCC       12.2.0 >= 5.1
OK:    GCC (C++) 12.2.0 >= 5.1
OK:    Grep      3.7    >= 2.5.1a
OK:    Gzip      1.12   >= 1.3.12
OK:    M4        1.4.19 >= 1.4.10
OK:    Make      4.3    >= 4.0
OK:    Patch     2.7.6  >= 2.5.4
OK:    Perl      5.36.0 >= 5.8.8
OK:    Python    3.11.1 >= 3.4
OK:    Sed       4.8    >= 4.1.5
OK:    Tar       1.34   >= 1.22
OK:    Texinfo   6.8    >= 5.0
OK:    Xz        5.2.6  >= 5.0.0
OK:    Linux Kernel 6.1.1 >= 4.14
OK:    Linux Kernel supports UNIX 98 PTY
Aliases:
OK:    awk  is GNU
OK:    yacc is Bison
OK:    sh   is Bash
Compiler check:
OK:    g++ works
```
