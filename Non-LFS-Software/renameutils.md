# renameutils

Simple tools to bulk rename and bulk copy files:

* `qmv` lets you quickly move large numbers of files using a text editor. I use it all the time.
* `imv` lets you rename a file by editing its name using `readline`
* `qcp` and `icp` are like `qmv` and `imv`, but let you copy files instead of moving them
* `deurlname` renames a file, replacing URL-encoded characters (like `%20`) with their plain-text equivalent.

## Installation

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

