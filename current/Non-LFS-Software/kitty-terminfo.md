# Kitty Terminfo

Terminfo database for Kitty, the terminal I generally prefer on most systems, including my laptop. Installing the terminfo is needed for Ncurses to work properly.

## Package Information

* Download (HTTP): https://github.com/kovidgoyal/kitty/releases/download/v0.30.1/kitty-0.30.1.tar.xz

## Installation

```sh
cd terminfo
mkdir output
tic kitty.termcap -o output
```

As *root*:

```sh
install -m644 output/x/xterm-kitty /usr/share/terminfo/x/
```

### Command Explanations

* `tic kitty.termcap -o output`: this command compiles the termcap file into a compiled terminfo file. The `-o output` flag outputs it into the newly-created output directory, rather than overwrite the one included with the kitty source code.
