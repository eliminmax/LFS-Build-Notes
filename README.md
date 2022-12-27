# LFS Build Notes
Made after the Github gist I was using for build notes got to be a bit too undwieldy.

Neovim was freezing up - presumably was stuck due to needing to deal with syntax highlighting for the entire kernel configuration. I decided to create the repo to be able to continue documenting it, but split into multiple files.

The current build notes are in the **Build-Notes.md** file.

The build notes as of the point when I first completed the system are in the **Original-Build-Notes.md**.


## Kernel build config

The kernel builds in the **kernel-configs** directory are named as follows:

`config-$KERNEL_VERSION-$LFS_VERSION-$LOCAL_IDENTIFIER`.

The current version is `config-6.1.1-lfs-11.2-systemd-eliminmax-0`

Some (but not all) of the files in /etc/ on the LFS system are also in this repo's /etc/ directory.
