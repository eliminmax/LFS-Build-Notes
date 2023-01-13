# renameutils

Simple tools to bulk rename and bulk copy files:

* `qmv` lets you quickly move large numbers of files using a text editor. I use it all the time.
* `imv` lets you rename a file by editing its name using `readline`
* `qcp` and `icp` are like `qmv` and `imv`, but let you copy files instead of moving them
* `deurlname` renames a file, replacing URL-encoded characters (like `%20`) with their plain-text equivalent.

## Installation

```sh
wget https://download.savannah.gnu.org/releases/renameutils/renameutils-0.12.0.tar.gz
wget https://raw.githubusercontent.com/eliminmax/LFS-Build-Notes/main/Non-LFS-Software/patches/renameutils-0.12.0-eliminmax-unified-patch-1.patch
tar xf renameutils-0.12.0.tar.gz
cd renameutils-0.12.0
patch -Np1 ../renameutils-0.12.0-eliminmax-unified-patch-1.patch
./configure                                   \
  --prefix=/usr                               \
  --sysconfdir=/etc                           \
  --docdir=/usr/share/doc/renameutils-0.12.0 &&
  make
sudo make install
```

