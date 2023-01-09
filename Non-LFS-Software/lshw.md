# lshw B.02.19.2

Simple tool to list hardware info.

## Installation
```sh
wget https://www.ezix.org/software/files/lshw-B.02.19.2.tar.gz
tar xf lshw-B.02.19.2.tar.gz
cd lshw-B.02.19.2
make
sudo make install
sudo mv /usr/share/man/man1/lshw.1 /usr/share/man/man8/lshw.8
# correct man page title
sudo sed -i '/^\.TH/s/"1"/"8"/' /usr/share/man/man8/lshw.8
```
