# LFS Build Notes

Made after the Github gist I was using for build notes got to be a bit too undwieldy.

The current build notes are in the **Build-Notes.md** file.

The build notes as of the point when I first completed the system are in the **Original-Build-Notes.md**.

The non-B/LFS software I included are listed in the **Build-Notes.md** file, and details about the software, including build/installation instructions, can be found in the **Non-LFS-Software/** directory.

## Configuration information

The kernel builds in the **kernel-configs** directory are named as follows:

`config-$KERNEL_VERSION-$LFS_VERSION-$LOCAL_IDENTIFIER`.

The current version is `config-6.1.1-lfs-11.2-systemd-eliminmax-1`

Some (but not all) of the files in /etc/ on the LFS system are also in the **etc/** subdirectory.
