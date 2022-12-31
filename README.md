# LFS Build Notes

Made after the Github gist I was using for build notes got to be a bit too undwieldy.

The current build notes are in the **Build-Notes.md** file.

The build notes as of the point when I first completed the system are in the **Original-Build-Notes.md**.

I'm in the process of moving the build processes for software I included from outside of B/LFS from **Build-Notes.md** to **Non-LFS-Software**, and formatting it in a manner similar to **BLFS**.

## Configuration information

The kernel builds in the **kernel-configs** directory are named as follows:

`config-$KERNEL_VERSION-$LFS_VERSION-$LOCAL_IDENTIFIER`.

The current version is `config-6.1.1-lfs-11.2-systemd-eliminmax-1`

Some (but not all) of the files in /etc/ on the LFS system are also in this repo's etc/ directory.
