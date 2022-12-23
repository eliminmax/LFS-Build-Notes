# Introduction

I'd been interested in building a custom Linux distro for a while, and LFS seemed like a good way to go about that. I was planning on working on that over Summer 2022, before my senior year of college, but when I was about to start, I got an email indicating that there was a 1-credit course being offered in the fall dedicated to doing just that, and I figured I might as well do it then instead. These are my notes on the process and any issues I run into.

# LFS Build/Configuration notes

I am using Linux From Scratch Version 11.2-systemd as a basis for my build, and will note any deviation from its instructions, or difficulties I ran into while working on it.

## Build environment

Building from within a Debian 11 VM running on a Pop!_OS 22.04 host system. The virtualisation stack consists of  QEMU+KVM as the hypervisor, and libvirt+virt-manager to manage it.

The `lfs-builder` VM has the following specs:
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

Running the `version-check.sh` script from Chapter 2.2 results in the following output:
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

## Partition Scheme

* 6 partitions:

Partition ID | Size | Type | Mountpoint | Block Size | UUID
-------------|------|------|------------|------------|---
`vdb1`       | 1M   | -    | -          | -          | -
`vdb2`       | 500K | ext4 | `/boot`    | 1024       | `f910cc92-a9c9-4492-bdd9-e0503444483c`
`vdb3`       | 25G  | ext4 | `/`        | 4096       | `9f92744a-8d9a-4377-9803-3df24ffe2bd9`
`vdb4`       | 512M | ext4 | `/var/log` | 4096       | `c748e430-6b34-44b2-afad-47701c75f7d3`
`vdb5`       | 4G   | swap | -          | -          | `5c3edb5e-89ee-49cd-a5f3-5155b46b675c`

## fstab file

```fstab
#/dev/vdb1: PARTUUID="36b65e60-bf70-e746-b4d6-fb254f1e0397"
#/dev/vdb2: UUID="f910cc92-a9c9-4492-bdd9-e0503444483c" BLOCK_SIZE="1024" TYPE="ext4" PARTUUID="d33a63d4-7977-e346-bbc1-344f30a23647"
#/dev/vdb3: UUID="9f92744a-8d9a-4377-9803-3df24ffe2bd9" BLOCK_SIZE="4096" TYPE="ext4" PARTUUID="a7fd248c-068c-7d4d-914f-0d72535fc9a3"
#/dev/vdb4: UUID="c748e430-6b34-44b2-afad-47701c75f7d3" BLOCK_SIZE="4096" TYPE="ext4" PARTUUID="826d8856-05d2-5f4a-9579-2c5bf88298ca"
#/dev/vdb5: UUID="5c3edb5e-89ee-49cd-a5f3-5155b46b675c" TYPE="swap" PARTUUID="fbfaf4e6-2927-f745-9296-a637e5f97f4d"
UUID=9f92744a-8d9a-4377-9803-3df24ffe2bd9 /        ext4 errors=remount-ro 0 1
UUID=f910cc92-a9c9-4492-bdd9-e0503444483c /boot    ext4 defaults          0 2
UUID=c748e430-6b34-44b2-afad-47701c75f7d3 /var/log ext4 defaults          0 2
UUID=5c3edb5e-89ee-49cd-a5f3-5155b46b675c none     swap defaults          0 0
```

## Diversions from LFS 11.2-systemd

### Changes coming from official errata

* Replaced expat 2.4.8 with expat 2.5.0 due to a security vulnerability in both the former and version 2.4.9
* Replaced the replacement of Python 3.10.6 with 3.10.7 due to a security vulnerability with 3.10.8 due to a security vulnerability
  * confused? It's simple - 3.10.6 had a security vulnerability, so LFS errata said to replace that with 3.10.7, but that version has had a different vulnerability found since then, so I went to the version that fixed that one instead. I then created this note because I thought it would mildly amuse me to come up with an overly verbose and confusing way of putting this. I was right about that.
* Fixed the sanity check in Chapter 5.5 to use `$LFS_TGT-gcc` instead of `gcc`
* Replaced zlib 11.2.12 with 11.2.13 due to a security vulnerability in the former "that could allow for trivial arbitrary code execution"
* Replaced inetutils 2.3 with inetutils 2.4 due to 2 security vulnerabilities found in the former

### Changes I made myself

* Instead of the `lfs` user, I'm working as `eliminmax` in the build system.
* Instead of the `.bash_profile` and `.bashrc` files that are found in Chapter 4.4, I used my own modified versions, seen below.
* I did not set a root password during Chapter 8 section 8.25. Shadow-4.12.2. Instead, I disabled root login entirely, installed sudo, created a user account (called `eliminmax`, not to be confused with my user on the build system of the same name), and gave it passwordless sudo options.)
* Once I completed the build, I replaced `/usr/bin/clear` with the amd64 variant of [`tiny-clear-elf`](https://github.com/eliminmax/tiny-clear-elf)
* Inspired by the way some BSD systems have both `root` and `toor` users with uid 0 but different login shells, I added the following line to `/etc/passwd`:
```passwd
lfschroot:x:0:0:root in LFS:/mnt/lfs:/usr/local/sbin/lfs_chroot_bash
```
I also appended the following to `/etc/shells`:
```conf
/usr/local/sbin/lfs_chroot_bash
```

The custom "shell" program is actually a shell script with the following content:
```sh
#!/bin/sh
. /etc/profile.d/lfs_var.sh
exec chroot "$LFS" /usr/bin/env -i HOME=/root TERM=xterm-256color PS1='(lfs chroot) \u:\w\$ ' PATH='/usr/bin:/usr/sbin' /bin/bash --login
```

This loads the `LFS` environment variable from `/etc/profile.d/lfs_var.sh`, then runs a bash login shell within the LFS chroot environment.

##### .bash_profile
```bash
exec env -i HOME="$HOME" TERM="$TERM" PS1="${PS1='\u:\w\$ '}" LFS="${LFS=/mnt/lfs}" /bin/bash
```
This does the following differently from the original:

* if `$LFS` and/or `$PS1` are already set, preserve their original value/s

##### .bashrc
```bash
set +h
umask 022
USER="${USER="$(whoami)"}"
LFS="$LFS"
LC_ALL=POSIX
LFS_TGT="$(uname -m)-lfs-linux-gnu"
PATH="$LFS/tools/bin:/usr/local/bin:/usr/bin"
CONFIG_SITE="$LFS/usr/share/config.site"
export LFS LC_ALL LFS_TGT PATH CONFIG_SITE USER
```

This does the following differently from the original:

* `$PATH` is defined on one line instead of 3
  * It does not check if `/bin` is a symlink or not - I already know it is on this system
  * `/usr/local/bin` is included in `$PATH`
* If not already set, the `USER` environment variable is defined with the output of `whoami` - this is so that the PROMPT_COMMAND function properly sets the terminal window title in `xterm`-like terminal emulators.
* I sometimes compiled multiple programs in parallel to save time without dealing with the issues from parallel jobs in one compilation - though I was cautious about this, because of potential missing or corrupt dependencies when doing things this way
* I did not disable `/etc/bash.bashrc` on the `lfs-builder` VM. If this causes a problem, I can reconsider, but I don't think it will. In order to be comprehensive, I am including its contents in this document:

Additionally, I briefly had the following at the end, but I removed it because it broke `scp`, preventing me from copying a backup of the LFS directory to my main system just in case.

```bash
if [ -f "$HOME/LFS-Status" ]; then
	source "$HOME/LFS-Status"
	echo "Current chapter: $CURRENT_CHAPTER"
	echo "Current section: $CURRENT_SUBCHAPTER"
	echo 'Don'\''t forget to keep ~/LFS-Status up-to-date!'
fi
```
##### /etc/bash.bashrc

```bash
# System-wide .bashrc file for interactive bash(1) shells.

# To enable the settings / commands in this file for login shells as well,
# this file has to be sourced in /etc/profile.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, overwrite the one in /etc/profile)
# but only if not SUDOing and have SUDO_PS1 set; then assume smart user.
if ! [ -n "${SUDO_USER}" -a -n "${SUDO_PS1}" ]; then
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

# Commented out, don't overwrite xterm -T "title" -n "icontitle" by default.
# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
    ;;
*)
    ;;
esac

# enable bash completion in interactive shells
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# if the command-not-found package is installed, use it
if [ -x /usr/lib/command-not-found -o -x /usr/share/command-not-found/command-not-found ]; then
	function command_not_found_handle {
	        # check because c-n-f could've been removed in the meantime
                if [ -x /usr/lib/command-not-found ]; then
		   /usr/lib/command-not-found -- "$1"
                   return $?
                elif [ -x /usr/share/command-not-found/command-not-found ]; then
		   /usr/share/command-not-found/command-not-found -- "$1"
                   return $?
		else
		   printf "%s: command not found\n" "$1" >&2
		   return 127
		fi
	}
fi
# Ansible Guest-Init additions #
PS1='\[\033[1;38;5;54m\]\u\[\033[1;38;5;170m\]@\h\[\033[39m\]:\[\033[38;5;123m\]\w\[\033[39m\]\$\[\033[0m\] '
## Shell options
shopt -s autocd
shopt -s checkwinsize
shopt -s cmdhist
shopt -s complete_fullquote
shopt -s expand_aliases
shopt -s extglob
shopt -s extquote
shopt -s force_fignore
shopt -s globasciiranges
shopt -s globstar
shopt -s interactive_comments
shopt -s progcomp
shopt -s promptvars
shopt -s sourcepath

## ALIASES
alias aliases='alias;'
alias c='clear;'
alias cl='clear;'
alias clear-hist='history -c > ~/.bash_history;'
alias d='cd'
alias dir='dir --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias h='history'
alias hi='echo "hello $(whoami)";'
alias ipconfig='ifconfig'
alias l='ls -F --color=auto'
alias la='ls -A --color=auto'
alias ll='ls -AlF --color=auto'
alias ls='ls --color=auto'
alias pinfo='ps -Flww -p'
alias t='tree'
alias v='vim'
alias vdir='vdir --color=auto'
alias vi='vim'
alias wanip='curl ifconfig.co;'

# Functions
newexec () {
  if [ $# -lt 1 ] || [ $# -gt 2 ]; then
      return 1
  else
      if [ $# -eq 2 ]; then
          echo "#!$2" > "$1"
      else
          touch "$1"
      fi
      chmod u+x "$1"
  fi
}
# Ansible Guest-Init additions #
```
(That last bit was added by an ansible playbook I use to initialize new VMs. I have since updated the aliases it adds.)

##### (POST-COMPLETION) /etc/profile, /etc/bashrc
* The file `/etc/profile.d/source-bashrc.sh` contains the following, adapted from the Debian `/etc/profile`.
```sh
# vi:ft=sh
if [ "${PS1-}" ]; then
    if [ "${BASH-}" ] && [ "$BASH" != "/bin/sh" ]; then
        # The file bash.bashrc already sets the default PS1.
        # PS1='\h:\w\$ '
        if [ -f /etc/bashrc ]; then
            . /etc/bashrc
        fi
    else
        if [ "$(id -u)" -eq 0 ]; then
            PS1='# '
        else
            PS1='$ '
        fi
    fi
fi
```
* the file `/etc/profile.d/editor.sh` contains the following:
```sh
export EDITOR=vim
```

* the `/etc/profile` file is as follows:
```sh
# Begin /etc/profile
# vi:ft=sh
# Written for Beyond Linux From Scratch
# by James Robertson <jameswrobertson@earthlink.net>
# modifications by Dagmar d'Surreal <rivyqntzne@pbzpnfg.arg>
#
# further local modifications by Eli Array Minkoff <eli@earrayminkoff.tech>

# System wide environment variables and startup programs.

# System wide aliases and functions should go in /etc/bashrc.  Personal
# environment variables and startup programs should go into
# ~/.bash_profile.  Personal aliases and functions should go into
# ~/.bashrc.

# Functions to help us manage paths.  Second argument is the name of the
# path variable to be modified (default: PATH)
pathremove () {
        local IFS=':'
        local NEWPATH
        local DIR
        local PATHVARIABLE=${2:-PATH}
        for DIR in ${!PATHVARIABLE} ; do
                if [ "$DIR" != "$1" ] ; then
                  NEWPATH=${NEWPATH:+$NEWPATH:}$DIR
                fi
        done
        export $PATHVARIABLE="$NEWPATH"
}

pathprepend () {
        pathremove $1 $2
        local PATHVARIABLE=${2:-PATH}
        export $PATHVARIABLE="$1${!PATHVARIABLE:+:${!PATHVARIABLE}}"
}

pathappend () {
        pathremove $1 $2
        local PATHVARIABLE=${2:-PATH}
        export $PATHVARIABLE="${!PATHVARIABLE:+${!PATHVARIABLE}:}$1"
}

export -f pathremove pathprepend pathappend

# Set the initial path
export PATH=/usr/local/bin:/usr/bin

# Attempt to provide backward compatibility with LFS earlier than 11
if [ ! -L /bin ]; then
        pathappend /bin
fi

if [ $EUID -eq 0 ] ; then
        pathappend /usr/sbin
        if [ ! -L /sbin ]; then
                pathappend /sbin
        fi
        unset HISTFILE
fi

# Setup some environment variables.
export HISTSIZE=1000
export HISTIGNORE="&:[bf]g:exit"

# Set some defaults for graphical systems
export XDG_DATA_DIRS=${XDG_DATA_DIRS:-/usr/share/}
export XDG_CONFIG_DIRS=${XDG_CONFIG_DIRS:-/etc/xdg/}
export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-/tmp/xdg-$USER}

for script in /etc/profile.d/*.sh ; do
        if [ -r $script ] ; then
                . $script
        fi
done


# End /etc/profile

```

* the /etc/bashrc file is as follows:
```sh
# system bashrc
if [[ -f /usr/share/bash-completion/bash_completion ]]; then
	. /usr/share/bash-completion/bash_completion
fi

## Shell options
shopt -s autocd
shopt -s checkwinsize
shopt -s cmdhist
shopt -s complete_fullquote
shopt -s expand_aliases
shopt -s extglob
shopt -s extquote
shopt -s force_fignore
shopt -s globasciiranges
shopt -s globstar
shopt -s interactive_comments
shopt -s progcomp
shopt -s promptvars
shopt -s sourcepath

# Set PS1
case "$TERM" in
	xterm-kitty|*-256color|alacritty)
		PS1='\[\e[1m\]{\[\e[38;5;178m\]\u@\h\[\e[39m\]} \[\e[38;5;246m\]\w \[\e[39m\]\$ \[\e[m\]'
	;; *)
		PS1='\[\e[1m\]{\e[0;33m\]\u@\h\[\e[1;39m\]} \[\e[37m\]\w \[\e[1;39m\]\$ \[\e[m\]'
	;;
esac

## ALIASES
alias clear-hist='history -c > ~/.bash_history;'
alias dir='dir --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias h='history'
alias l='ls -F'
alias la='ls -A'
alias ll='ls -AlF'
alias ls='ls --color=auto'
alias t='tree'
alias v='vim'
alias vdir='vdir --color=auto'
alias vi='vim'
alias c='clear'
alias cl='clear'
alias cls='clear'

# Functions
newexec () {
    if [ $# -lt 1 ] || [ $# -gt 2 ]; then
        return 1
    else
        if [ $# -eq 2 ]; then
            echo "#!$2" > "$1"
        else
            touch "$1"
        fi
        chmod u+x "$1"
    fi
}

# vi:ft=sh
```

# Additional Software
I included or intend to include some software not part of the LFS book

## From BLFS
I did not necessarily list the dependencies linked within the pages themselves

* Sudo-1.9.11p3
* OpenSSH-9.0p1
* Wget-1.21.3
* (POST-COMPLETION) cURL-7.84.0
* (POST-COMPLETION) LSB-Tools-0.1.0
* (POST-COMPLETION) Git-2.38.1
* (POST-COMPLETION) Which-2.21
* (POST-COMPLETION) LLVM-14.0.6
* (POST-COMPLETION) Rustc-1.60.0
* (POST-COMPLETION) tree-2.0.3
* (POST-COMPLETION) Linux-PAM-1.5.2

## Not From BLFS
* [bash-completion-2.11](https://github.com/scop/bash-completion/releases/tag/2.11)
* Oil-0.12.9-hist
  * [Oil](https://www.oilshell.org) is a new Unix shell, which aims to fix many of the security pitfalls and confusing parts of traditional Bourne-style shells. It comes with the bash-compatible `osh`. I patched it to change the path it saves the history file to, and I have an open pull request for the patch. I made a source release tarball using the process documented [here](https://github.com/oilshell/oil/wiki/Python-App-Bundle) in the Oil Github wiki. Building the release tarball requires an ANSI C environment, Bash, and GNU Make, with an optional dependency on GNU readline, so all of the dependencies are satisfied by the base LFS system. The build instructions will be documented later in this document, in the Software-specific notes.
* [Neofetch 7.1.0](https://github.com/dylanaraps/neofetch/releases/tag/7.1.0)
  * An eye-candy system info display tool written in bash

## Software-specific notes

### Why not all software is mentioned here
I am only listing things if an issue comes up in a specific step - otherwise, this section would look like the following:

---

##### (Example) 5.2. Binutils-2.39 - Pass 1

I ran the compilation job as described in the LFS book. The commands I ran were as follows:

```sh
tar -xf binutils-2.39.tar.xz
cd binutils-2.39

mkdir -v build
cd build

../configure --prefix=$LFS/tools \
             --with-ssysroot=$LFS \
             --target=$LFS_TGT   \
             --disable-nls       \
             --enable-gprofng=no \
             --disable-werror

make

make install
```

#### (Example) 5.3. GCC-12.2.0 - Pass 1

```sh
tar -xf gcc-12.2.0.tar.xz
cd gcc-12.2.0

tar -xf ../mpfr-4.1.0.tar.xz
mv -v mpfr-4.1.0 mpfr
tar -xf ../gmp-6.2.1.tar.xz
mv -v gmp-6.2.1 gmp
tar -xf ../mpc-1.2.1.tar.gz
mv -v mpc-1.2.1 mpc

case $(uname -m) in
  x8

  6_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
 ;;
esac

mkdir -v build
cd       build

../configure                  \
    --target=$LFS_TGT         \
    --prefix=$LFS/tools       \
    --with-glibc-version=2.36 \
    --with-sysroot=$LFS       \
    --with-newlib             \
    --without-headers         \
    --disable-nls             \
    --disable-shared          \
    --disable-multilib        \
    --disable-decimal-float   \
    --disable-threads         \
    --disable-libatomic       \
    --disable-libgomp         \
    --disable-libquadmath     \
    --disable-libssp          \
    --disable-libvtv          \
    --disable-libstdcxx       \
    --enable-languages=c,c++

make

make install

cd ..
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
  `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/install-tools/include/limits.h
```

---

Yeah, not going to do that for every step of the way. It's already gotten old with those two steps alone, and the info is just copied from the LFS book. Instead, I'm going to make a note of any steps that I run into trouble on, and whatever troubleshooting, workarounds, or external information/resources helped me troubleshoot. If I'm using a different version of a program, and all I need to do is replace the numbers in the command (e.g. `tar -xf zlib-1.2.13.tar.xz` instead of `tar -xf zlib-1.2.12.tar.xz`), I consider mentioning the version difference in the above Diversions section to be sufficient, and won't mention it explicitly here - I'll only mention substantial changes.

### 8.5. Glibc-2.36

On this one, a bunch of tests from `make check` failed. Some failures were expected, and were detailed in the LFS book, but I got significantly more, with a total of 43 tests with the `FAIL` status, and another 16 with the `XFAIL` status. My first build and test were done without the special file systems mounted within the chroot environment (I'd forgotten to mount them after booting it up), so I mounted them and tried again, `tee`ing the output to a separate file, as there was too much to store in the terminal emulator's scrollback (in the end, it totaled 47573 lines, and the output file was 24 MiB of plain text - not much storage space, but quite a lot of text. That time, I only got 3 `FAIL`ures (but still had 16 `XFAIL`ures). Two of these were mentioned in the book as being "known to fail in the LFS chroot environment," but the remaining one (`c++-types-check`) was quite alarming, and I couldn't make sense of it, so I tried going back to square one - I deleted the `glibc-2.36` directory, extracted a fresh version from `glibc-2.36.tar.xz`, applied `glibc-2.36-fhs-1.patch`, and went from there, following the instructions in the book. This time, I had several new failures (`libio/tst-fgetc-after-eof` `login/tst-grantpt` `posix/tst-spawn6` `wcsmbs/tst-fgetwc-after-eof`), but the `c++-types-check` test was fine. Turns out that was because when trying to fix the issue with the missing special file system mounts, I'd somehow damaged the process by which pseudo-terminals can be allocated - which I realized when trying to discuss the issue with my dad, I tried to start another SSH session. Rebooting the system, remounting the special file systems, and rerunning each of those tests individually with `make test t={TEST_NAME}` succeeded.

To prevent similar issues from happening again, I edited the helper script I use to mount the special file systems to use a fairly basic, naïve system to check if it has already been run since boot:
```bash
#!/bin/bash

# Fall back to hard-coded /mnt/lfs directory if LFS is not defined
LFS="${LFS=/mnt/lfs}"

if [ -f /run/lfs_mounted ]; then echo "Already mounted"; exit 1; fi

mount --bind /dev "$LFS/dev"
mount --bind /dev/pts "$LFS/dev/pts"
mount -t proc lfs_proc "$LFS/proc"
mount -t sysfs lfs_sysfs "$LFS/sys"
mount -t tmpfs lfs_run "$LFS/run"

if [ -h "$LFS/dev/shm" ]; then
        mkdir -p "$LFS/$(readlink "$LFS/dev/shttps://github.com/fr0zn/hedhm")"
fi

touch /run/lfs_mounted
```
### 8.11. Readline-8.1.2

I realized that since I last worked on the LFS system, I'd shut down the build VM while I went to grab dinner, and upon returning, I forgot to mount the special file systems, breaking the `./configure` script, as it tried to redirect output to /dev/null. This is particularly frustrating given that I first ran into this issue less than an hour after solving the previous issue with a related cause.

### 8.13. Bc-6.0.1

The issue with this one is simply that I was tired, and instead of `CC=gcc ./configure --prefix=/usr -G -O3 -r`, I somehow typed `CC=gcc ./configure --prefix=/usr -G -03 -r1` - notice the `0` instead of an `O`, and the extra `1` that I must have typed by mistake without noticing. Once I copied and pasted the command straight from the book, it worked fine.

### 8.18. Binutils-2.39

I saw some things in the `make -k check` output that I thought indicated failures, but were not actually problems. I did not realize that until my second build.

### 8.69.1 Vim-9.0.0228

I ran into the same issue as I did in **8.11 Readline-8.1.2**, but caught it immediately this time. The strange thing is that I'd built 15 packages successfully since the last reboot.

### Oil 0.12.9-hist

* Release tarball is available at time of writing at https://dl.earrayminkoff.tech/oil-0.12.9-hist.tar.gz.
* MD5 sum is `33459a3ac8acf1c00982e1f19c8372d6`. MD5 is a known-broken algorithm, but LFS uses it anyway, so whatever.

Building this one is not all that different from the packages included in LFS. Once in the `oil-0.12.9-hist` directory, run the following:

```sh
./configure --prefix /usr --datarootdir /usr/share --with-readline
make
./install
```

*(Do note that it's `./install`, rather than `make install`)*

Oil can optionally use readline for line editing features.

This installs the `oil.ovm` binary, and symlinks pointing to it called `oil` and `osh`. It maintains bash compatibility if invoked as `osh`, but aims to improve the Unix shell experience in ways that are incompatible with `bash` if invoked as `oil`

### Bash-completion 2.11
Release tarball is available at https://github.com/scop/bash-completion/releases/download/2.11/bash-completion-2.11.tar.xz

This one is not all that different from those included in LFS

```sh
./configure --prefix=/usr
make
make install
```

After installed, you'll still need to source the completion script in each session to run it: `. /usr/share/bash-completion/bash_completion`.
To do that automatically, add the following to your user's `.bashrc` and `.bash_profile`
```sh
# Use bash-completion, if available
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion
```

### Neofetch

Release tarball is available at https://github.com/dylanaraps/neofetch/archive/refs/tags/7.1.0.tar.gz

To install, just run the following:
```sh
make PREFIX=/usr install
```

### (POST-COMPLETION) BLFS Wget-1.21.3

There's a complex web of optional dependencies for this one. I went with `libidn2`, `libpsl`, and `pcre2`. Unfortunately, I messed up the order of building the dependencies, but running `sudo make uninstall` and rerunning the `./configure` commands fixed it.

### BLFS cURL-7.84.0

`CMake` can use its own version of `curl`, or the system `curl`. At the same time, `curl` has optional dependencies on `c-ares` and `brotli`, both of which require `CMake` to build. I alreay had the optional dependencies `libidn2` and `libpsl`. I compiled the following, all of which can be found in BLFS. The repeated appearances of `CMake` and `curl` are because I built `CMake`, built `curl`, built `CMake` again using the system `curl`, then rebuilt `curl` linked agains the optional `c-ares` and `brotli` dependencies I mentioned earlier in this paragraph. In retrospect, the first build of `CMake` was never used. that aside, it went smoothly.

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

### (POST-COMPLETION) BLFS Git-2.37.2

Bit of a large dependency tree - none necessary, but I wanted to include some of them.

#### Already installed:
* `cURL`
* `OpenSSH`
* `pcre2`
* `Nettle`
* `make-ca`
* `libunistring`
* `libtasn1`
* `p11-kit`
* `libidn2`

#### Installation Order:
1. `npth`
2. `libusb`
3. `libgpg-error`
4. `Pth`
5. `Net-tools`
6. `libassuan`
7. `libgcrypt`
8. `libksba`
9. `GnuTLS`
10. `pinentry`
11. `GnuPG`
12. `Git`

### (POST-COMPLETION) renameutils 0.12.0

Simple tools to bulk rename and bulk copy files:

* `qmv` lets you quickly move large numbers of file s using a text editor. I use it all the time.
* `imv` lets you rename a file by editing it using `readline`
* `qcp` and `icp` are like `qmv` and `imv`, but let you copy files instead of moving them
* `deurlname` renames a file with url-encoded characters (like `%20`) to their plain-text equivalent.

This one looked like it'd be simple enough - the instructions were to just run `./configure`, `make`, then `make install`. Unfortunately, due to a typo in the Makefile, the `make install` failed. I figured I could look into the way it was built for established distros, so on my host system, I ran `apt source renameutils` to download the source that the Pop!_OS build is made from, and found 2 patches - `install-exec-local-fix.patch` and `typo_fix.patch`. Applying those patches in that order right after extracting the `renameutils` source archive fixed it.

Download link for the source tarball: https://download.savannah.gnu.org/releases/renameutils/renameutils-0.12.0.tar.gz
MD5 Checksum for the source tarball: `a859898a25589e3b19ac8f78ddabb606`

Download links for the patches:
* https://sources.debian.org/data/main/r/renameutils/0.12.0-9/debian/patches/install-exec-local-fix.patch
* https://sources.debian.org/data/main/r/renameutils/0.12.0-9/debian/patches/typo_fix.patch

MD5 Checksum for the patches:
`install-exec-local-fix.patch`: `61bd52097029ee1ea1d26562e457158e`
`typo_fix.patch`:               `9c9c7e46dcf1ce00f3ad68904f6acb65`

I prepended "`renameutils-` to the beginning of the names of my patches.

Build instructions:

```sh
patch -Np1 ../renameutils-install-exec-local-fix.patch
patch -Np1 ../renameutils-typo_fix.patch
./configure                                   \
  --prefix=/usr                               \
  --sysconfdir=/etc                           \
  --docdir=/usr/share/doc/renameutils-0.12.0 &&
  make
```

Installation instructions:

as *root*, run `make install`


### (POST-COMPLETION) BLFS Rustc-1.60.0

The dependencies for this one were `cURL`, `CMake`, `libssh2`, `LLVM` (recommended), and `GDB` (optional), all of which are also in BLFS. Of those, I'd already built `cURL` and `CMake`, and `libssh2` was easy enough to build, but `LLVM` took 30 SBUs to build, and I accidentally interrupted it about 2/3 of the way through the process. Luckily, it picked up right where it left off when I tried to relaunch the build command.

Reading the `rustc` docs page on bootstrapping (available [here](https://rustc-dev-guide.rust-lang.org/building/bootstrapping.html)) while it was compiling was interesting. The original version of `rustc` was written in OCaml, and future versions were written in Rust. The OCaml version is too old to use to compile a modern version of `rustc`, so now you need to acquire a fairly recent existing build to bootstrap it. This is automated by a script called `x.py` in the source tarballs for `rustc`. It works as follows.

1. It downloads the latest beta build of `rustc` - this is the "stage0 compiler"
2. It builds a minimal version of the Rust standard library ("std") with the stage0 compiler - this is the "stage0 std"
3. It builds the dependencies of `rustc` - these are the "stage0 artifacts".
4. It builds `rustc`, using stage0 std and stage0 artifacts - this is the "stage1 compiler"
5. It repeats steps 2 and 3 with the "stage1 compiler" to make the "stage1 std" and "stage1 artifacts"
6. It builds the version of `rustc` that actually gets installed using the stage1 std and stage1 artifacts - this is the "stage2 compiler"

I removed the part of `/etc/profile.d/rustc.sh` that edits MANPATH, because if MANPATH is unset, it will check any `share/man` subdirectory in the same directory as a directory in the PATH, so it's not necessary, and prevents `man` from finding manpages in `/usr/share/man`.
### (POST-COMPLETION) libevent 2.1.12

Libevent is a dependency for `tmux`, itself a dependency for `byobu`.
The source archive is available at https://github.com/libevent/libevent/releases/download/release-2.1.12-stable/libevent-2.1.12-stable.tar.gz

Building is simple:

```sh
./configure --prefix=/usr --sysconfdir=/etc --disable-static && make
```

As root:
```sh
make install
```

### (POST-COMPLETION) tmux 3.3a

A **t**erminal **mul**tiplexer with an uncreative name. Used as a backend by `byobu` - a "terminal window manager" I often use when multitasking.
The source archive is available at https://github.com/tmux/tmux/releases/download/3.3a/tmux-3.3a.tar.gz

```sh
./configure --prefix=/usr --sysconfdir=/etc --docdir=/usr/share/doc/tmux-3.3a && make
```

As root:
```sh
make install
```

### (POST-COMPLETION) byobu 5.133

A "terminal window manager" that I like to use for multitasking. Uses either GNU `screen` or `tmux` as a backend.

Source tarball: https://launchpad.net/byobu/trunk/5.133/+download/byobu_5.133.orig.tar.gz
MD5 Checksum: 0ff03f3795cc08aae50c1ab117c03261

```sh
./configure --prefix=/usr --sysconfdir=/etc --docdir=/usr/share/doc/byobu-5.133 --localstatedir=/var
make
```

As root:
```sh
make install
```

### (POST-COMPLETION) bat 0.22.1

"A cat(1) clone with wings"

Source tarball: https://github.com/sharkdp/bat/archive/refs/tags/v0.22.1.tar.gz

This one took some work - it's designed to be built with `cargo`, which is a tool for both managing packages and dependencies for rust programs. I ultimately got it working with the following:

```sh
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

### (POST-COMPLETION) hexyl 0.12.0

A hexdump utility with colors and fancy output

Source tarball: https://github.com/sharkdp/hexyl/archive/refs/tags/v0.12.0.tar.gz

```sh
cargo build --release --bins --locked
sudo strip target/release/hexyl -o /usr/bin/hexyl
```

### (POST-COMPLETION) fd 8.6.0

An alternative to `find` that's easier to use and has saner defaults

Source tarball: https://github.com/sharkdp/fd/archive/refs/tags/v8.6.0.zip

```sh
cargo build --release --bins --locked
sudo strip target/release/fd -o /usr/bin/fd
sudo cp doc/fd.1 /usr/share/man/man1
```

### (POST-COMPLETION) Hed [Commit 44d3eb70dc62a1bdd2ae0f84f5993d654a73799c]

A simple vi-like hex editor with minimal dependencies

This one's designed to install from the `master` branch. Not great practice, but whatever.

```sh
git clone https://github.com/fr0zn/hed && cd hed
# ensure you're on the same commit I was working from
git checkout 44d3eb
# fix hard-coded paths in the Makefile
sed 's@local/@@g' -i Makefile
make
sudo make install
```
***Full Disclosure:*** *I have contributed a commit to adjust the hard-coded paths in the Makefile to be more consistent. Originally, it installed the binary to `/usr/bin/hed` and the man page to `/usr/local/share/man/man1`. I edited the Makefile to install both to the `/usr/local` prefix, so had I done the opposite, the `sed` command would not be needed. I opened the request on August 26th, but it was not merged until December 11th.*

### (POST-COMPLETION) BLFS Linux-PAM-1.5.2

I messed up this one.

I compiled Linux-PAM, then I recompiled the following to use it:
* Systemd
* libcap
* Sudo
* Shadow
* OpenSSH

Unfortunately, I messed up the order, and couldn't do anything that required root privileges.

I had to mount the LFS qcow2 hard drive with `guestmount` and chroot in to fix the configuration files at `/etc/pam.d`.

### (POST-COMPLETION) Newt-r0-52-23 + dependencies

The `byobu-config` script bundled with `byobu` and used to configure it has a runtime dependency on snack.

Newt is a text-mode windowing toolkit written in C, and snack is a bundled Python module that interfaces with it. It is not the same as the snack on the Python Package Index.

Newt has a bit of a dependency tree I had to work out, with some dependencies already resolved, some included in BLFS, and some that I had to track down on the internet.

Text diagram of Newt's tree of unresolved dependencies:
```
Newt
| |
| popt
|
S-lang
 | | \
 | | PCRE
 | |
 | oniguruma
 |
 libpng
```

popt is a library for parsing command line arguments.

S-lang (or slang) is an interpreted language meant to be embedded into a program, much like lua. It has optional dependencies on PCRE, libpng, oniguruma, and zlib. Not knowing which of those were needed by newt, and that libpng and PCRE are also dependencies of other things I wanted to install, I figured I'd just install the 3 that were not already part of the base LFS system.

PCRE is a library providing **P**erl **C**ompatible **R**egular **E**xpressions. It has been officially deprecated in favor of pcre2, but it is still in use.

onigmura is a regex library that provides several different regex variants.

libpng is the official PNG reference library

Non-BLFS Source tarballs:
* popt: https://ftp.osuosl.org/pub/rpm/popt/releases/popt-1.x/popt-1.19.tar.gz
* oniguruma: https://github.com/kkos/oniguruma/releases/download/v6.9.8/onig-6.9.8.tar.gz
* s-lang: https://www.jedsoft.org/releases/slang/slang-2.3.3.tar.bz2
* newt: https://pagure.io/newt/archive/r0-52-23/newt-r0-52-23.tar.gz

At this point, I decided that moving forward, if I could get the following to work, I would not explicitly memtion the build/install process. Not all of the arguments are needed for all software, but they won't hurt.

```sh
./configure --disable-static --prefix=/usr --sysconfdir=/etc --localstatedir=/var --docdir=/usr/share/doc/$pkg-$pkg_version
make
sudo make install
```

So yeah, I built all of the dependencies for the runtime dependency for `byobu-config`.

### (POST-COMPLETION) Xorg-7

I followed the instructions on the following pages from the BLFS section titled "Part VI. Graphical Components", with any differences or difficulties noted:

* Introduction to Xorg-7
* util-macros-1.19.3
* xorgproto-2022.2
* libXau-1.0.9
* libXdmcp-1.1.3
* xcb-proto-1.15.2
* libxcb-1.15
* Xorg Libraries
  * depends on Fontconfig, which I had yet to build, so before building, I built FreeType (without HarfBuzz, but with libpng, which, and Brotli), then Fontconfig, then followed the instructions on this page
* libxcvt-0.1.2
* xcb-util-0.4.0
  * suddenly, I couldn't connect to freedesktop.org (or any subdomains) from my LFS system. Not sure why - it could connect to other domains, and the host system could connect to it, but it eventually passed.
* Mesa-22.1.7
  * Had to go through the dependency tree, and installed all that were listed as either required or recommended
  * All libraries that had been built with `meson` had been installed to `/lib64`, and were not being picked up.
    * I messed uo fixing this several times, and had to rebuild several times to fix this. From now on, whenever building something with `meson`, I'm passing the following extra arguments to it no matter what: `-Dlibdir=/usr/lib -Dbackend=ninja -Dstrip=true -Ddebug=false`
  * To resolve the circular dependency between Mesa and libva, I first built libva, then intel-vaapi-driver, then Mesa, then I rebuilt each of them again.
    * before the second libva build, I ran `make distclean` and re-ran the configuration process.
    * `make distclean` actually removed a critical file from the intel-vaapi-driver directory, so I re-extracted the source tarball for the second build.
    * for the second Mesa build, I returned to the "build" subdirectory, and re-ran the `meson` command with the `--reconfigure` command
      * This had the benifit of only needing to rebuild 22 of the over 2000 objects built the first time around
* xbitmaps-1.1.2
* Xorg Applications
  * Failed when it came time to build xbacklight because xcb-atom and xcb-aux were not found. Rebuilding and reinstalling xcb-util fixed this.
  * Instead of using the `as_root` shell function from the BLFS book, I just replaced `as_root` with `sudo`.
* Xorg Fonts
  * I once again replaced `as_root` with `sudo`
* XKeyboardConfig-2.36
* Xorg-Server-21.1.4
  * Had to go down the dependency tree. Like with Mesa, if it's either required or recommended, I built it.
    * There were 3 dependencies not already installed - Pixman, libepoxy, and libtirpc. None of them had required or recommended dependencies, and no issues came up when building them.

# Miscellaneous Issues

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

# Future Plans

I am planning to continue to work on this system as a hobby, at least for a bit. I might try to install a graphical environment - probably based around Xfce4, replace Vim with Neovim (which has more complex dependencies), install [`hed`](https://github.com/fr0zn/hed) and more. I might try to add the ability to run foreign binaries with `binfmt_misc` and `qemu`, and see if I can get flatpak set up. Also might install VSCodium (VSCode without telemetry or proprietary blobs), and see what limits I can push. These are just ideas, and this is not a system I plan on daily-driving, but I do plan on having fun and geeking out with it.
