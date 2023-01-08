# Nerd Fonts v2.2.2

Fonts patched to have symbols useful in various nerdy contexts - such as Linux distro logos, file type icons, and fancy prompt components. I installed a subset of the UbuntuMono and VictorMono Nerd Fonts.

```sh
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/VictorMono.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/UbuntuMono.zip
mkdir nerdfonts
cd nerdfonts
unzip ../VictorMono.zip
# both zip files contain a file called `readme.md`. Don't overwrite it.
yes n | unzip ../UbuntuMono.zip
# remove unneeded files and variants
rm readme.md LICENSE
# Fonts ending in `Windows Compatible.ttf` are not needed on this system
rm *Windows\ Compatible.ttf
# Fonts ending in `Complete.ttf` are not monospaced - the orignal was, but the Nerd Font symbols aren't.
rm *Complete.ttf
sudo install -v -dm755 /usr/share/fonts/X11-TTF
sudo cp * /usr/share/fonts/X11-TTF
```
