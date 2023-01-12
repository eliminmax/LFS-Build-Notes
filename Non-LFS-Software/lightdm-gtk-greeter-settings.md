# LightDM GTK+ Greeter Settings

A graphical settings app, which integrates with the XFCE4 settings manager, and manages the LightDM GTK+ greeter.

Dependencies:
* Python3 GOBject-Introspection bindings (BLFS Python Modules)
* lightdm-gtk-greeter (BLFS lightdm)
* gdk-pixbuf (BLFS gdk-pixbuf)
* GTK3+ (BLFS GTK+-3)
* Pango (BLFS Pango)
* Polkit (BLFS Polkit-121, updated on my system to Polkit-122)
* python-distutils-extra ([deps/python-modules:python-distutils-extra](./deps/python-modules.md#python-distutils-extra))

Of those, I had to build the Python3 GOBject-Introspection bindings and python-distutils-extra along with intltool. I build the former using the BLFS instructions, and the latter two, along with the package itself, as follows:

I originally installed it with `sudo pip3 install --no-index --find-links dist --no-cache-dir lightdm-gtk-greeter-settings`, but that resulted in a broken installation.

## Installation

```sh
wget https://github.com/Xubuntu/lightdm-gtk-greeter-settings/releases/download/lightdm-gtk-greeter-settings-1.2.2/lightdm-gtk-greeter-settings-1.2.2.tar.gz

tar xf lightdm-gtk-greeter-settings-1.2.2.tar.gz
cd lightdm-gtk-greeter-settings-1.2.2

pip3 wheel -w dist --no-build-isolation --no-deps $PWD
sudo python3 setup.py install --optimize=1 --xfce-integration
```
