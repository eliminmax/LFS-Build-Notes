# Hed

A simple vi-like hex editor with minimal dependencies.

This one's designed to install from the `master` branch.

## Installation

```sh
git clone https://github.com/fr0zn/hed hed-44d3eb7
cd hed-44d3eb7
# ensure you're on the same commit I was working from
git checkout 44d3eb7
# fix hard-coded paths in the Makefile
sed 's@local/@@g' -i Makefile
make
sudo make install
```
