# Bash Completion

Completion scripts for bash. Without them, tab completion would only complete file names.

## Package Information

* Download (HTTP): https://github.com/scop/bash-completion/releases/download/2.11/bash-completion-2.11.tar.xz

## Installation

```sh
./configure --prefix=/usr --sysconfdir=/etc
make
mv 
```

As *root*:
```sh
make install
```

## Usage

To use it, you must source the main completion script from within bash:

```sh
. /usr/share/bash-completion/bash_completion
```

You can add that to your shell startup file, but I'd recommend checking that it exists first:

```sh
# within .bash_profile, /etc/profile, or some other shell startup file
if [[ -f /etc/profile.d/bash_completion.sh ]]; then
        . /etc/profile.d/bash_completion.sh
fi
```
