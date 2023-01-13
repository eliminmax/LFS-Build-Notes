# Bash Completion

Completion scripts for bash. Without them, tab completion would only complete file names.

## Installation

```sh
wget https://github.com/scop/bash-completion/releases/download/2.11/bash-completion-2.11.tar.xz
tar xf bash-completion-2.11.tar.xz
cd bash-completion-2.11
./configure --prefix=/usr
make
sudo make install
```

## Usage

To use it, you must source the main completion script from within bash:

```sh
. /usr/share/bash-completion/bash_completion
```

You can add that to your shell startup file, but I'd recommend checking that it exists first:

```sh
# within .bash_profile, /etc/profile, or some other shell startup file
if [[ -f /usr/share/bash-completion/bash_completion ]]; then
        . /usr/share/bash-completion/bash_completion
fi
```
