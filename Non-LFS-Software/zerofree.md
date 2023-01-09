# zerofree

Zerofree makes it easier to reclaim unused space from virtual hard disks with ext2, ext3, or ext4 filesystems, by zeroing out unused data blocks, which may contain remnants of deleted files.

The drive must be mounted read-only while zerofree runs.


## Installation

```sh
wget https://frippery.org/uml/zerofree-1.1.1.tgz
tar xf zerofree-1.1.1.tgz
cd zerofree-1.1.1
CFLAGS='-O2' make
sudo install -m744 zerofree /usr/sbin
```

## Usage

Reboot to GRUB, and edit the menu entry by pressing the "E" key

Locate the line that begins with `linux`, and append ` single init=/bin/bash` to it, and press f10 (or ctrl+x) to reboot.

For every partition you want to shrink, run `fsck` on it, then run `zerofree` on it, then run `fsck` again.

For example, my root file system partition is on **/dev/vda3**, so I'd run the following:

```sh
fsck.ext4 /dev/vda3
zerofree -v /dev/vda3
fsck.ext4 /dev/vda3
```
